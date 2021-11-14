// SPDX-License-Identifier: Unliscenced

pragma solidity 0.7.5;

contract MultiSigWallet {
    
    address owner;
    address[] approversAddrs;
    uint numApproval;
    mapping(address => uint) balance;
    mapping(address => bool) approver;
    
    constructor() {
        owner = msg.sender;
        numApproval = 1;
        approver[msg.sender] = true;
        approversAddrs.push(owner);
    }
    
    function deposit() public payable returns (uint) {
        balance[msg.sender] += msg.value;
        return balance[msg.sender];
    }
    
    function registerNewApprovers(address[] memory _newApproversAddrs, uint _numApproval) public returns (bool) {
        require(msg.sender == owner, "Only Contract Owner can execute this function");
        require(_numApproval > 0, "Number of approvals needs to be more than zero");
        require(_numApproval <= _newApproversAddrs.length + approversAddrs.length, "The number of approvals must be less than the number of approvers");
        for (uint i=0; i<_newApproversAddrs.length; i++) {
            require(!approver[_newApproversAddrs[i]], "Input address is already an approver");
        }
        
        numApproval = _numApproval;
        
        for (uint i=0; i<_newApproversAddrs.length; i++) {
            approver[_newApproversAddrs[i]] = true;
            approversAddrs.push(_newApproversAddrs[i]);
        }
        return true;
    }
    
    function updateNumApproval(uint _numApproval) public returns (bool) {
        require(_numApproval > 0, "Number of approvals needs to be more than zero");
        require(_numApproval <= approversAddrs.length, "The number of approvals must be less than the number of approvers");
        numApproval = _numApproval;
        return true;
    }
    
    function getContractOwner() public view returns (address) {
        return owner;
    }
    
    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }
    
    function getApprovalRight() public view returns (bool) {
        return approver[msg.sender];
    }
    
    function getRequiredNumApproval() public view returns (uint) {
        return numApproval;
    }
    
    function getApprovalInfo() public view returns (address[] memory, uint) {
        return (approversAddrs, numApproval);
    }
    
}