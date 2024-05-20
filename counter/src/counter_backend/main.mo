import Nat "mo:base/Nat";
actor Counter {
  stable var value: Nat = 0;

  public func inc() : async Nat {
    value += 3;
    return value;
  };
}
