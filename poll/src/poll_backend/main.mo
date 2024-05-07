import Text "mo:base/Text";
import Iter "mo:base/Iter";
import RbTree "mo:base/RBTree";
import Nat "mo:base/Nat";


actor {
  var question: Text = "What is your favorite programming language?";

  var votes: RBTree.RBTree<Text, Nat> = RBTree.RBTree(Text.compare);


  public query func getQuestion(): async Text {
    question
  }
};
