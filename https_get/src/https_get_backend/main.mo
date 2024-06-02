import Types "Types";
import Text "mo:base/Text";
import Nat64 "mo:base/Nat64";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";

actor {
	let Host : Text = "api.pro.coinbase.com";
	let ONE_MINUTE : Nat64 = 60;

	// function to transform's the raw content into an HTTP payload.
	public query func transform(raw : Types.TransformArgs) : async Types.CanisterHttpResponsePayload {
		let transformed : Types.CanisterHttpResponsePayload = {
			status = raw.response.status;
			body = raw.response.body;
			headers = [
				{ name = "Content-Security-Policy"; value = "default-src 'self'" },
				{ name = "Referrer-Policy"; value = "strict-origin" },
				{ name = "Permissions-Policy"; value = "geolocation=(self)" },
				{ name = "Strict-Transport-Security"; value = "max-age=63072000"},
				{ name = "X-Frame-Options"; value = "DENY" },
				{ name = "X-Content-Type-Options"; value = "nosniff" },
			];
		};
		transformed;
	};

	// This function sends our GET request.
	public func get_icp_usd_exchange() : async Text {
		let start_timestamp : Types.Timestamp = 1682978460; //May 1, 2023 22:01:00 GMT
    	let end_timestamp : Types.Timestamp = 1682978520; //May 1, 2023 22:02:00 GMT
		let url : Text = "https://" # Host
			# "/products/ICP-USD/candles?start="
			# Nat64.toText(start_timestamp)
			# "&end=" # Nat64.toText(end_timestamp)
			# "&granularity="
			# Nat64.toText(ONE_MINUTE);

		// Management canister.
		let ic : Types.IC = actor("aaaaa-aa");

		let request_headers : [Types.HttpHeader] = [
			{ name = "Host"; value = Host # ":443" },
        	{ name = "User-Agent"; value = "exchange_rate_canister" },
		];

		let transform_context : Types.TransformContext = {
			function = transform;
			context = Blob.fromArray([]);
		};

		let request : Types.HttpRequestArgs = {
			url = url;
			max_response_bytes = null; //optional for request
			headers = request_headers;
			body = null; //optional for request
			method = #get;
			transform = ?transform_context;
		};

		// Now, you need to add some cycles to your call, since cycles to pay for the call must be transferred with the call.
		// The way Cycles.add() works is that it adds those cycles to the next asynchronous call.
		// "Function add(amount) indicates the additional amount of cycles to be transferred in the next remote call".
		// See: https://internetcomputer.org/docs/current/references/ic-interface-spec/#ic-http_request

		Cycles.add(20_949_972_000);

		let response : Types.HttpResponsePayload = await ic.http_request(request);

		// Once you have the response, you need to decode it. The body of the HTTP response should come back as [Nat8], which needs to be decoded into readable text.
		// To do this, you:
		//  1. Convert the [Nat8] into a Blob
		//  2. Use Blob.decodeUtf8() method to convert the Blob to a ?Text optional
		//  3. Use a switch to explicitly call out both cases of decoding the Blob into ?Text

		let response_body : Blob = Blob.fromArray(response.body);
		let decoded_text : Text = switch(Text.decodeUtf8(response_body)) {
			case(null) { "No value returned" };
			case(?y) { y };
		};

		// The API response will looks like this:
		// ("[[1682978460,5.714,5.718,5.714,5.714,243.5678]]")

		// Which can be formatted as this
		//  [
		//     [
		//         1682978460, <-- start/timestamp
		//         5.714, <-- low
		//         5.718, <-- high
		//         5.714, <-- open
		//         5.714, <-- close
		//         243.5678 <-- volume
		//     ],
		// ]

		decoded_text;
	};
};
