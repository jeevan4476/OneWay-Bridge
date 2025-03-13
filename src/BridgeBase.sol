// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;


import { ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
// import {console} from "froge-std/console.sol";

interface IJCOIN  is IERC20{
    function mint(address _to, uint256 _amount) external;
    function burn(address _from , uint256 _amount) external;
}

contract BridgeETH is Ownable{
    address public tokenAddress;
    uint256 public balance;

    mapping (address => uint256) pendingBalance;
    
    event Burn(address indexed burner , uint256 amount);

    constructor (address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

    function withdraw (IJCOIN _tokenAddress , uint256 _amount) public{
        require(pendingBalance[msg.sender] >= _amount, "Insufficient balance");
        require(address(_tokenAddress) == tokenAddress);
        pendingBalance[msg.sender] -= _amount;  
    _tokenAddress.mint(msg.sender, _amount);
    }

    function burn(IJCOIN _tokenAddress , uint256 _amount) public{
        require(address(_tokenAddress) == tokenAddress);
        _tokenAddress.burn(msg.sender, _amount);
        emit Burn(msg.sender, _amount);
    }
    function depositOnOtherChain(address userAccount , uint256 _amount) public onlyOwner{
        pendingBalance[userAccount] += _amount;
    }

}