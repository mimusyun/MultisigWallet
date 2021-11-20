// SPDX-License-Identifier: Unliscenced

pragma solidity 0.7.5;
pragma abicoder v2;

contract MultiSigWallet {
    
    struct TransferRequest {
        address fromAddr;
        address payable toAddr;
        uint amount;
        bool complete;
    }
    
    address[] public owners;
    uint approvalLimit;
    TransferRequest[] transferReqs;
    
    /* transferApprovalCnt {FromAddress => {ToAddress => {TrxIdx => ApproveCnt}} */
    mapping(address => mapping(address => mapping(uint => uint))) transferApprovalCnt;
    
    mapping(address => uint) balance;
    mapping(address => bool) isApproved;
    
    modifier onlyOwners() {
        require(isApproved[msg.sender], "Address not owner");
        _;
    }
    
    constructor(address[] memory _owners, uint _approvalLimit) {
        require(_owners.length >= _approvalLimit, "The number of required approvals cannot exceed the number of approvers");
        owners = _owners;
        approvalLimit = _approvalLimit;
        for (uint i=0; i<_owners.length; i++) {
            isApproved[_owners[i]] = true;
        }
    }
    
    function deposit() public payable {
        balance[msg.sender] += msg.value;
    }
    
    function createTransferRequest(uint amount, address payable recipient) public onlyOwners {
        require(msg.sender != recipient, "Don't transfer money to yourself");
        transferReqs.push(TransferRequest(msg.sender, recipient, amount, false));
    } 
    
    function approveTransferRequest(uint id) public onlyOwners {
        require(!transferReqs[id].complete, "Transfer already complete");
        require(balance[transferReqs[id].fromAddr] >= transferReqs[id].amount, "Balance not sufficient");
        transferApprovalCnt[transferReqs[id].fromAddr][transferReqs[id].toAddr][id] += 1;
        if (transferApprovalCnt[transferReqs[id].fromAddr][transferReqs[id].toAddr][id] >= approvalLimit) {
            balance[transferReqs[id].fromAddr] -= transferReqs[id].amount;
            balance[transferReqs[id].toAddr] += transferReqs[id].amount;
            transferReqs[id].complete = true;
        }
    }
    
    /* Getter below */
    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }
    
    function getApprovalRight() public view returns (bool) {
        return isApproved[msg.sender];
    }
    
    function getRequiredNumApproval() public view returns (uint) {
        return approvalLimit;
    }
    
    function getTransferRequests() public view returns (TransferRequest[] memory){
        return transferReqs;
    }
    
}