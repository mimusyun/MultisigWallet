# MultisigWallet
A multisig wallet is a wallet where multiple “signatures” or approvals are needed for an outgoing transfer to take place.

## Requirements
* Anyone should be able to deposit ether into the smart contract
* The contract creator should be able to input (1): the addresses of the owners and (2):  the numbers of approvals required for a transfer, in the constructor. For example, input 3 addresses and set the approval limit to 2. 
* Anyone of the owners should be able to create a transfer request. The creator of the transfer request will specify what amount and to what address the transfer will be made.
* Owners should be able to approve transfer requests.
* When a transfer request has the required approvals, the transfer should be sent. 


## Test Scenario on remix
1. Deploy Contract with args:

    MultiSigWallet(["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", "0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c"], 2);
    
2. Call deposit() from each account:

    "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", 10000000
    "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2", 20000000
    "0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c", 30000000
    
3. Create Transfer:

    Go to the account "0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c"
    transfer(5000000, "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4");
    
4. Approve Transfer:

    Go to the account "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2"
    approve(0);
    
    Go to the account "0xCA35b7d915458EF540aDe6068dFe2F44E8fa733c"
    approve(0);
    
5. Check Balance
    
