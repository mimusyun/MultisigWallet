// SPDX-License-Identifier: Unliscenced

pragma solidity 0.7.5;

contract MultiSigWallet {
    
    // TODO impl TransferRequest struct
    // TODO add TransferRequestQueue
    address owner;
    address[] ownerAddrs;
    uint numApproval;
    mapping(address => uint) balance;
    mapping(address => bool) isApproved;
    
    constructor(address[] memory _ownerAddrs, uint _numApproval) {
        require(_numApproval > 0, "Number of approvals needs to be more than zero");
        require(_numApproval <= _ownerAddrs.length, "The number of required approvals cannot exceed the number of approvers");
        owner = msg.sender;
        ownerAddrs = _ownerAddrs;
        numApproval = _numApproval;
        for (uint i=0; i<_ownerAddrs.length; i++) {
            isApproved[_ownerAddrs[i]] = true;
        }
    }
    
    function deposit() public payable {
        balance[msg.sender] += msg.value;
    }
    
    function transferRequest(uint amount, address recipient) public {
        require(balance[msg.sender] >= amount, "Balance not sufficient");
        require(msg.sender != recipient, "Don't transfer money to yourself");
        // TODO push event to TransferRequestQueue
    } 
    
    function getContractOwner() public view returns (address) {
        return owner;
    }
    
    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }
    
    function getApprovalRight() public view returns (bool) {
        return isApproved[msg.sender];
    }
    
    function getRequiredNumApproval() public view returns (uint) {
        return numApproval;
    }
    
    function getApprovalInfo() public view returns (address[] memory, uint) {
        return (ownerAddrs, numApproval);
    }
    
}