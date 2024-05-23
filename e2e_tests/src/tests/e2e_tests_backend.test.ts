import { expect, test } from "vitest";
import { Actor, CanisterStatus, HttpAgent } from "@dfinity/agent";
import { Principal } from "@dfinity/principal";
import { e2e_tests_backend, e2e_tests_backendCanister } from "./actor";

test("should handle a basic greeting", async () => {
  const result = await e2e_tests_backend.greet("test");
  expect(result).toBe("Hello, test!");
});

test("should contain a candid interface", async () => {
  const agent = Actor.agentOf(e2e_tests_backend) as HttpAgent;
  const id = Principal.from(e2e_tests_backendCanister);

  const canisterStatus = await CanisterStatus.request({
    canisterId: id,
    agent,
    paths: ["time", "controllers", "candid"],
  });

  expect(canisterStatus.get("time")).toBeTruthy();
  expect(Array.isArray(canisterStatus.get("controllers"))).toBeTruthy();
  expect(canisterStatus.get("candid")).toMatchInlineSnapshot(`
    "service : {
      greet: (text) -> (text) query;
    }
    "
  `);
});
