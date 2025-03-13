// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/BridgeETH.sol";
import "src/WJcoin.sol";


contract BridgeEth is Test{
     BridgeETH bridge;
    WJcoin token;

    address owner = address(this);
    address user = address(0x123);

    function setUp() public {
        token = new WJcoin();
        bridge = new BridgeETH(address(token));

        // Owner mints tokens to user
        token.mint(user, 1000 ether);
        vm.startPrank(user);
        token.approve(address(bridge), 1000 ether);
        vm.stopPrank();
    }

    function testLockTokens() public {
        vm.startPrank(user);
        bridge.lock(IERC20(token), 500 ether);
        vm.stopPrank();

        assertEq(token.balanceOf(address(bridge)), 500 ether);
        assertEq(token.balanceOf(user), 500 ether);
    }

    // function testFailLockWithoutApproval() public {
    //     vm.startPrank(user);
    //     token.approve(address(bridge), 0); // Remove approval
    //     bridge.lock(IERC20(token), 500 ether); // Should fail
    //     vm.stopPrank();
    // }

    function testUnlockTokens() public {
        vm.prank(owner);
        token.mint(address(bridge), 500 ether);
        bridge.depositOnOtherChain(user, 500 ether);

        vm.startPrank(user);
        bridge.unlock(IERC20(token), 500 ether);
        vm.stopPrank();

        assertEq(token.balanceOf(user), 1500 ether); // User gets back tokens
    }

    // function testFailUnlockWithoutBalance() public {
    //     vm.startPrank(user);
    //     bridge.unlock(IERC20(token), 500 ether); // Should fail
    //     vm.stopPrank();
    // }

    // function testOnlyOwnerCanDepositOnOtherChain() public {
    //     vm.prank(user);
    //     vm.expectRevert("Ownable: caller is not the owner");
    //     bridge.depositOnOtherChain(user, 500 ether);
    // }

}
