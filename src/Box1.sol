// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Box1 {
    uint256 private value;

    function getValue() public view returns (uint256) {
        return value;
    }

    function getVersion() public pure returns (uint256) {
        return 1;
    }
}
