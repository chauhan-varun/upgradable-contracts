// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Box2 {
    uint256 private value;

    function getValue() public view returns (uint256) {
        return value;
    }

    function getVersion() public pure returns (uint256) {
        return 2;
    }

    function setValue(uint256 newValue) public {
        value = newValue;
    }
}
