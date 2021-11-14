// SPDX-License-Identifier: Unliscenced

pragma solidity 0.7.5;

contract MultiSigWallet {
    
    address owner;
    mapping(address => uint) balance;
    
    constructor() {
        owner = msg.sender;
    }
    
    function getOwner() public view returns (address) {
        return owner;
    }
    
    function deposit() public payable returns (uint) {
        balance[msg.sender] += msg.value;
        return balance[msg.sender];
    }
    
    function getBalance() public view returns (uint) {
        return balance[msg.sender];
    }
    
}