// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// OpenZeppelin Upgradeable Contracts
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

/**
 * @title Box1
 * @author Varun Chauhan
 * @notice This is the initial version of an upgradeable storage contract implementing the UUPS pattern
 * @dev This contract demonstrates basic upgradeable functionality with a simple storage variable.
 *      It serves as the foundation that can be upgraded to more feature-rich versions.
 *
 * Key Features:
 * - UUPS (Universal Upgradeable Proxy Standard) implementation
 * - Owner-controlled upgrades for security
 * - Simple value storage and retrieval
 * - Version tracking for upgrade management
 *
 * Security Considerations:
 * - Only the owner can authorize upgrades
 * - Initializers are disabled in the constructor to prevent direct implementation calls
 * - Follows OpenZeppelin's upgradeable contract patterns
 */
contract Box1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    /*//////////////////////////////////////////////////////////////
                           STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    /// @dev Private storage variable that holds a uint256 value
    /// @notice This value is initialized to 0 and remains constant in Box1
    uint256 private value;

    /*//////////////////////////////////////////////////////////////
                              EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @dev Emitted when the contract is initialized
    /// @param initializer The address that initialized the contract
    event ContractInitialized(address indexed initializer);

    /*//////////////////////////////////////////////////////////////
                            CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Constructor that disables initializers for the implementation contract
     * @dev This prevents the implementation contract from being initialized directly.
     *      Only proxy contracts should be able to call initialize().
     * @custom:oz-upgrades-unsafe-allow constructor
     */
    constructor() {
        _disableInitializers();
    }

    /*//////////////////////////////////////////////////////////////
                           INITIALIZATION
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Initializes the contract with ownership and UUPS upgrade capability
     * @dev This function replaces the constructor for upgradeable contracts.
     *      It can only be called once due to the `initializer` modifier.
     *
     * Requirements:
     * - Can only be called once
     * - Sets the deployer as the initial owner
     * - Initializes the UUPS upgrade mechanism
     *
     * @custom:security This function sets up critical contract permissions
     */
    function initialize() public initializer {
        // Initialize ownership with the caller as the owner
        __Ownable_init(msg.sender);

        // Initialize UUPS upgrade capability
        __UUPSUpgradeable_init();

        // Emit initialization event for transparency
        emit ContractInitialized(msg.sender);
    }

    /*//////////////////////////////////////////////////////////////
                          PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Retrieves the current stored value
     * @dev Returns the private `value` state variable
     * @return The current value stored in the contract (always 0 in Box1)
     *
     * Note: In Box1, this value cannot be modified and will always return 0.
     * Future versions may implement value modification functionality.
     */
    function getValue() public view returns (uint256) {
        return value;
    }

    /**
     * @notice Returns the version number of this contract implementation
     * @dev This is a pure function that always returns 1 for Box1
     * @return The version number (1) indicating this is the first implementation
     *
     * Usage: This function helps identify which version of the contract is currently deployed.
     * It's particularly useful after upgrades to verify the correct implementation is active.
     */
    function getVersion() public pure returns (uint256) {
        return 1;
    }

    /*//////////////////////////////////////////////////////////////
                         INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
     * @notice Authorizes contract upgrades - restricted to owner only
     * @dev This function is called by the UUPS upgrade mechanism to verify upgrade authorization.
     *      It implements the security model where only the contract owner can upgrade.
     *
     * @param newImplementation The address of the new implementation contract
     *
     * Requirements:
     * - Caller must be the contract owner (enforced by `onlyOwner` modifier)
     * - newImplementation should be a valid contract address (checked by UUPS mechanism)
     *
     * Security: This is a critical function that controls contract upgradeability.
     * The `onlyOwner` modifier ensures that only authorized parties can upgrade the contract.
     */
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {
        // Authorization logic is handled by the onlyOwner modifier
        // Additional upgrade validation logic can be added here if needed
    }
}
