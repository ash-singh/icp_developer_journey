import Text "mo:base/Text";
import Nat "mo:base/Nat";
import RBTree "mo:base/RBTree";
import Iter "mo:base/Iter";
import Debug "mo:base/Debug";

actor {
    var question: Text = "what is your favorite programming language?";
    var votes: RBTree.RBTree<Text, Nat> = RBTree.RBTree(Text.compare);

    public query func getQuestion() : async Text {
        question
    };

    public query func getVotes() : async [(Text, Nat)]{
        Iter.toArray(votes.entries());
    };

    public func vote(entry: Text) : async [(Text,Nat)] {
        let existing_vote :Nat = switch (votes.get(entry)) {
            case null 0;
            case (?Nat) Nat;
        };

        votes.put(entry, existing_vote + 1);

        Iter.toArray(votes.entries());
    };

    public func resetVotes() : async [(Text, Nat)] {
        // iterate all entries and reset vote to zero
        for (entry in votes.entries()) {
            Debug.print("Entry key=" # debug_show(entry.0) # " value=\"" # debug_show(entry.1) #"\"");
            votes.put(entry.0, 0);
        };

        Iter.toArray(votes.entries())
    };
};
