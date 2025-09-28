// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// OpenZeppelin Upgradeable Contracts
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/**
 * @title Box2
 * @author Varun Chauhan
 * @notice This is the upgraded version of Box1 with enhanced functionality for value modification
 * @dev This contract extends Box1's capabilities by adding value modification functionality.
 *      It maintains storage compatibility while introducing new features.
 *
 * New Features in v2:
 * - setValue() function allows modification of the stored value
 * - Maintains all existing functionality from Box1
 * - Enhanced version tracking (returns 2)
 *
 * Upgrade Compatibility:
 * - Storage layout is compatible with Box1
 * - All existing functions maintain the same signatures
 * - New functionality is additive, not breaking
 *
 * Security Model:
 * - setValue() is public (no access restrictions)
 * - Only owner can authorize further upgrades
 * - Follows OpenZeppelin's upgradeable patterns
 */
contract Box2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    /*//////////////////////////////////////////////////////////////
                           STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    /// @dev Private storage variable that holds a uint256 value
    /// @notice This value can now be modified using the setValue() function (new in v2)
    uint256 private value;

    /*//////////////////////////////////////////////////////////////
                              EVENTS
    //////////////////////////////////////////////////////////////*/

    /// @dev Emitted when the contract is initialized
    /// @param initializer The address that initialized the contract
    event ContractInitialized(address indexed initializer);

    /// @dev Emitted when the value is updated
    /// @param previousValue The previous value before update
    /// @param newValue The new value after update
    /// @param updatedBy The address that performed the update
    event ValueUpdated(
        uint256 indexed previousValue,
        uint256 indexed newValue,
        address indexed updatedBy
    );

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
     *      When upgrading from Box1, this function is typically not called again.
     *
     * Requirements:
     * - Can only be called once
     * - Sets the deployer as the initial owner
     * - Initializes the UUPS upgrade mechanism
     *
     * @custom:security This function sets up critical contract permissions
     * @custom:upgrade When upgrading from Box1, existing state is preserved
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
     * @return The current value stored in the contract
     *
     * Note: In Box2, this value can be modified using the setValue() function.
     * The value persists across contract upgrades due to proxy storage pattern.
     */
    function getValue() public view returns (uint256) {
        return value;
    }

    /**
     * @notice Returns the version number of this contract implementation
     * @dev This is a pure function that always returns 2 for Box2
     * @return The version number (2) indicating this is the second implementation
     *
     * Usage: This function helps identify which version of the contract is currently deployed.
     * Returning 2 indicates this is the upgraded version with setValue capability.
     */
    function getVersion() public pure returns (uint256) {
        return 2;
    }

    /**
     * @notice Updates the stored value to a new value
     * @dev This is a new function introduced in Box2 that allows value modification.
     *      The function is public, meaning anyone can call it to update the value.
     *
     * @param newValue The new value to store in the contract
     *
     * Effects:
     * - Updates the internal `value` state variable
     * - Emits a ValueUpdated event for transparency
     * - Changes persist across future upgrades (stored in proxy)
     *
     * @custom:security This function has no access control - anyone can call it
     * @custom:feature This functionality is new in Box2 and not available in Box1
     */
    function setValue(uint256 newValue) public {
        uint256 previousValue = value;
        value = newValue;

        // Emit event for value change transparency
        emit ValueUpdated(previousValue, newValue, msg.sender);
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
     *
     * @custom:upgrade This function enables further upgrades to Box3, Box4, etc.
     */
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {
        // Authorization logic is handled by the onlyOwner modifier
        // Additional upgrade validation logic can be added here if needed
        // For example: version checks, feature flags, or time-based restrictions
    }
}
