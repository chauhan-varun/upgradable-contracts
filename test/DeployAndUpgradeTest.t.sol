// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Test, console2} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {Box1} from "../src/Box1.sol";
import {Box2} from "../src/Box2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox deployer;
    UpgradeBox upgrader;
    address owner = makeAddr("owner");
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
}
