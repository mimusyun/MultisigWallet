// SPDX-License-Identifier: Unliscenced

pragma solidity 0.7.5;

contract MultiSigWallet {
    
    struct TransferRequest {
        address fromAddr;
        address payable toAddr;
        uint amount;
        bool complete;
    }
    
    TransferRequest[] transferReqs;
    
    /* transferApprovalCnt {FromAddress => {ToAddress => {TrxIdx => ApproveCnt}} */
    mapping(address => mapping(address => mapping(uint => uint))) transferApprovalCnt;
    
    address owner;
    uint numRequiredApproval;
    mapping(address => uint) balance;
    mapping(address => bool) isApproved;
    
    constructor(address[] memory _ownerAddrs, uint _numRequiredApproval) {
        require(_numRequiredApproval > 0, "Number of approvals needs to be more than zero");
        require(_numRequiredApproval <= _ownerAddrs.length, "The number of required approvals cannot exceed the number of approvers");
        owner = msg.sender;
        numRequiredApproval = _numRequiredApproval;
        for (uint i=0; i<_ownerAddrs.length; i++) {
            isApproved[_ownerAddrs[i]] = true;
        }
    }
    
    function deposit() public payable {
        balance[msg.sender] += msg.value;
    }
    
    function createTransferRequest(uint amount, address payable recipient) public {
        require(isApproved[msg.sender], "Address not owner");
        require(msg.sender != recipient, "Don't transfer money to yourself");
        transferReqs.push(TransferRequest(msg.sender, recipient, amount, false));
    } 
    
    function approveTransferRequest(uint id) public {
        require(isApproved[msg.sender], "Address not owner");
        require(!transferReqs[id].complete, "Transfer already complete");
        require(balance[transferReqs[id].fromAddr] >= transferReqs[id].amount, "Balance not sufficient");
        transferApprovalCnt[transferReqs[id].fromAddr][transferReqs[id].toAddr][id] += 1;
        if (transferApprovalCnt[transferReqs[id].fromAddr][transferReqs[id].toAddr][id] >= numRequiredApproval) {
            balance[transferReqs[id].fromAddr] -= transferReqs[id].amount;
            balance[transferReqs[id].toAddr] += transferReqs[id].amount;
            transferReqs[id].complete = true;
        }
    }
    
    /* Getter below */
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
        return numRequiredApproval;
    }
    
}