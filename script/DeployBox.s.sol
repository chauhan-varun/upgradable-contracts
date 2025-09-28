// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Script} from "forge-std/Script.sol";
import {Box1} from "../src/Box1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployBox is Script {
    function run() external returns (address) {
        return deployBox1();
    }

    function deployBox1() public returns (address) {
        vm.startBroadcast();
        Box1 box = new Box1();
        ERC1967Proxy proxy = new ERC1967Proxy(address(box), "");
        Box1(address(proxy)).initialize();
        vm.stopBroadcast();
        return address(proxy);
    }
}
