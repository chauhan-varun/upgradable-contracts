// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Box2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 private value;

    // @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize() public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
    }

    function getValue() public view returns (uint256) {
        return value;
    }

    function getVersion() public pure returns (uint256) {
        return 2;
    }

    function setValue(uint256 newValue) public {
        value = newValue;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
