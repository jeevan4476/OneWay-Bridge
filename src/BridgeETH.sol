// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;


import { ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
// import {console} from "lib/froge-std/src/console.sol";

contract BridgeETH is Ownable{
    uint256 public balance;
    address public tokenAddress;

    mapping(address => uint256) public pendingBalance;

    event Deposit (address indexed depositor , uint256 indexed amount);

    constructor (address _tokenaddress) Ownable(msg.sender) {
        tokenAddress = _tokenaddress;
    }

    function lock (IERC20 _tokenAddress , uint256 _amount ) public{
        require(address(_tokenAddress) == tokenAddress);
        require(_tokenAddress.allowance(msg.sender, address(this))>= _amount);
        bool success = _tokenAddress.transferFrom(msg.sender, address(this), _amount);
        require(success, "Token transfer failed"); 
        emit Deposit(msg.sender,_amount);
    }

    function unlock(IERC20 _tokenAddress , uint256 _amount) public{
        require(address(_tokenAddress) == tokenAddress);
        require(pendingBalance[msg.sender] >= _amount);
         pendingBalance[msg.sender] -= _amount; 
        _tokenAddress.transfer(msg.sender, _amount);
    }
    
    function depositOnOtherChain(address userAccount, uint256 _amount) public onlyOwner{
        pendingBalance[userAccount] += _amount;
    }

}