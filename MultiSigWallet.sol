// SPDX-License-Identifier: Unliscenced

pragma solidity 0.7.5;

contract MultiSigWallet {
    
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
    
    function deposit() public payable returns (uint) {
        balance[msg.sender] += msg.value;
        return balance[msg.sender];
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