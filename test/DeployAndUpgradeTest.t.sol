// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Test, console2} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {Box1} from "../src/Box1.sol";
import {Box2} from "../src/Box2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox deployer;
    UpgradeBox upgrader;
    address owner = makeAddr("owner");
    address nonOwner = makeAddr("nonOwner");
    address proxy;

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.run();
    }

    function testUpgrade() public {
        Box2 box2 = new Box2();
        upgrader.upgradeBox(proxy, address(box2));

        assertEq(Box2(proxy).getVersion(), 2);

        Box2(proxy).setValue(42);
        assertEq(Box2(proxy).getValue(), 42);
    }

    function testRevertSetValueBeforeUpgrade() public {
        vm.expectRevert();
        Box2(proxy).setValue(4);
    }

    // Test Box1 specific functions for 100% coverage
    function testBox1GetValue() public view {
        // Test getValue function on Box1 proxy
        assertEq(Box1(proxy).getValue(), 0); // Initial value should be 0
    }

    function testBox1GetVersion() public view {
        // Test getVersion function on Box1 proxy
        assertEq(Box1(proxy).getVersion(), 1);
    }

    // Test Box2 initialize function
    function testBox2Initialize() public {
        // Deploy a new Box2 implementation
        Box2 box2Implementation = new Box2();

        // Deploy proxy with initialization call
        bytes memory initData = abi.encodeCall(Box2.initialize, ());
        ERC1967Proxy newProxy = new ERC1967Proxy(
            address(box2Implementation),
            initData
        );

        // Verify initialization worked
        Box2 proxiedBox2 = Box2(address(newProxy));
        assertEq(proxiedBox2.getVersion(), 2);
        assertEq(proxiedBox2.getValue(), 0);

        // setValue is public in Box2, so anyone can call it
        // Test that both owner and non-owner can set value
        vm.prank(nonOwner);
        proxiedBox2.setValue(100);
        assertEq(proxiedBox2.getValue(), 100);

        // Owner can also set value
        proxiedBox2.setValue(200);
        assertEq(proxiedBox2.getValue(), 200);
    }

    // Test _authorizeUpgrade function (only owner can upgrade)
    function testBox2AuthorizeUpgradeOnlyOwner() public {
        // First upgrade to Box2
        Box2 box2 = new Box2();
        upgrader.upgradeBox(proxy, address(box2));

        // Create another Box2 implementation for the upgrade
        Box2 anotherBox2 = new Box2();

        // Non-owner should not be able to upgrade
        vm.prank(nonOwner);
        vm.expectRevert();
        upgrader.upgradeBox(proxy, address(anotherBox2));

        // Owner should be able to upgrade (this tests _authorizeUpgrade)
        upgrader.upgradeBox(proxy, address(anotherBox2));
    }

    // Test complete Box2 functionality after initialization
    function testBox2CompleteFlow() public {
        // Deploy fresh Box2 with proper initialization
        Box2 box2Implementation = new Box2();
        bytes memory initData = abi.encodeCall(Box2.initialize, ());
        ERC1967Proxy newProxy = new ERC1967Proxy(
            address(box2Implementation),
            initData
        );
        Box2 proxiedBox2 = Box2(address(newProxy));

        // Test all functions for complete coverage
        assertEq(proxiedBox2.getValue(), 0);
        assertEq(proxiedBox2.getVersion(), 2);

        proxiedBox2.setValue(999);
        assertEq(proxiedBox2.getValue(), 999);
    }

    // Test Box1 _authorizeUpgrade function
    function testBox1AuthorizeUpgradeOnlyOwner() public {
        // Create implementation for upgrade
        Box1 newBox1Implementation = new Box1();

        // Non-owner should not be able to upgrade
        vm.prank(nonOwner);
        vm.expectRevert();
        upgrader.upgradeBox(proxy, address(newBox1Implementation));

        // Owner should be able to upgrade (this tests Box1's _authorizeUpgrade)
        upgrader.upgradeBox(proxy, address(newBox1Implementation));
    }
}
