// uniquely identify with principal id, get by dfx identity get-principal

import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token {

    let owner : Principal = Principal.fromText("4i3vh-ut2bh-4bww7-r4dhr-5yanb-teggl-zdnl7-2xsfx-3gvzb-57i4b-cqe");
    let totalSupply : Nat = 1000000000; // 1 billion : minted 1 billions
    let symbol : Text = "DUKE";

    private stable var balanceEntries : [(Principal, Nat)] = [];

    // who owns how much
    private var balances = HashMap.HashMap<Principal, Nat>(1, Principal.equal, Principal.hash);
    // as marked private, balances can only be modified from within the actor, by the actor methods

    if (balances.size() < 1){
        // add owner to hashmap, which is the ledger
        balances.put(owner, totalSupply);  // giving all the tokens to the owner, that is Me.
    }

    public query func balanceOf(who: Principal) : async Nat {
        // if (balances.get(who) == null){
        //     return 0;
        // }
        // else {
        //     return balances.get(who);  // returns ?Nat and not Nat dataType. Which means the returned value can be null or Nat
            //                                  To handle this we use switch case
        // }
        let balance : Nat = switch(balances.get(who)){
            case null 0;
            case (?result) result;
        };
        return balance;
    };

    // get the symbol of currency from backend
    public query func getSymbol() : async Text {
        return symbol;
    };

    public shared(msg) func payOut() : async Text {
        // Debug.print(debug_show(msg.caller));   // prints out the users principal id
        if (balances.get(msg.caller) == null){
            let amount = 10000;
            // balances.put(msg.caller, amount);
            let result = await transfer(msg.caller, amount);
            return result;
        }
        else return "Already Claimed";
    };

    // when we call method from another method, the actor get a separate principal id
    public shared(msg) func transfer(to: Principal, amount: Nat) : async Text{
        // the function is called by a user with their principal id, we take input the principal id we want to send to and the amount
        let fromBalance = await balanceOf(msg.caller);
        if (fromBalance >= amount){   // subtract the amount from payers account and add to the receivers
            let newFromBalance : Nat = fromBalance - amount;
            balances.put(msg.caller, newFromBalance);

            let toBalance = await balanceOf(to);    
            let newToBalance = toBalance + amount;
            balances.put(to, newToBalance);

            return "Success"; 
        }     
        else {
            return "Insufficient Funds";
        }  
    };

    system func preupgrade() {  // shift enteries into array as there is no stable hashmap, array can be stable, 
                                //  but array search operation expensive compared to hashmap
        balanceEntries := Iter.toArray(balances.entries());
    };

    system func postupgrade() {
        balances := HashMap.fromIter<Principal, Nat>(balanceEntries.vals(), 1, Principal.equal, Principal.hash);

        if (balances.size() < 1){
            // add owner to hashmap, which is the ledger
            balances.put(owner, totalSupply);  // giving all the tokens to the owner, that is Me.
        }
    };

}