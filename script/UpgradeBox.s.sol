// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Script, console} from "forge-std/Script.sol";
import {Box1} from "../src/Box1.sol";
import {Box2} from "../src/Box2.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract UpgradeBox is Script {
    function run() external returns (address) {
        address box1Proxy = DevOpsTools.get_most_recent_deployment(
            "ERC1967Proxy",
            block.chainid
        );
        console.log("Box1 Proxy Address:", box1Proxy);

        vm.startBroadcast();
        Box2 box2 = new Box2();
        vm.stopBroadcast();

        console.log("Box2 Implementation Address:", address(box2));
        return upgradeBox(box1Proxy, address(box2));
    }

    function upgradeBox(
        address proxyAddress,
        address newBox
    ) public returns (address) {
        vm.startBroadcast();
        Box1 proxy = Box1(payable(proxyAddress));
        proxy.upgradeToAndCall(address(newBox), "");
        vm.stopBroadcast();
        return address(proxy);
    }
}
