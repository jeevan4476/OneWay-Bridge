// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/WJcoin.sol";

contract TestContract is Test {
    WJcoin c;

    address owner = address(this); // Test contract acts as the owner
    address user = address(0x123);

    function setUp() public {
        c = new WJcoin();
    }

    function testMintByOwner() public{
        uint256 amount = 1 ether;
        c.mint(user, amount);
        assertEq(c.balanceOf(user), amount);
    }

    // function testFailNotMintByOwner() public{
    //     vm.prank(user);
    //     c.mint(user, 1 ether);
    // }

    function testBurnByOwner() public {
        uint256 amount = 500 ether;
        c.mint(user, amount);

        assertEq(c.balanceOf(user), amount);
        c.burn(user, amount);
        assertEq(c.balanceOf(user), 0);
    }

    //  function testFailNotBurnByOwner() public{
    //     uint256 amount = 1 ether;
    //     c.mint(user, amount);

    //     vm.prank(user);
    //     c.burn(user, amount);
    // }

    function testTransfer() public{
        uint256 amount = 1 ether;
        c.mint(owner,amount);

        c.transfer(user, amount);

        assertEq(c.balanceOf(user), amount);
        assertEq(c.balanceOf(owner), 0);
    }
}
