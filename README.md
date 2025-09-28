# Upgradeable Smart Contracts with OpenZeppelin UUPS

This project demonstrates the implementation and testing of upgradeable smart contracts using OpenZeppelin's **UUPS (Universal Upgradeable Proxy Standard)** pattern with Foundry framework.

## 📋 Overview

The project consists of two upgradeable contract versions:
- **Box1**: Basic upgradeable contract with `getValue()` and `getVersion()` functions
- **Box2**: Enhanced version adding a `setValue()` function for state modification

Both contracts implement the UUPS upgradeable pattern using:
- `Initializable` - Prevents multiple initialization calls
- `OwnableUpgradeable` - Access control for upgrade authorization
- `UUPSUpgradeable` - UUPS proxy pattern implementation

## 🏗️ Contract Architecture

### Box1.sol
```solidity
contract Box1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 private value;
    
    function initialize() public initializer;
    function getValue() public view returns (uint256);
    function getVersion() public pure returns (uint256); // Returns 1
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner;
}
```

### Box2.sol (Upgraded Version)
```solidity
contract Box2 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 private value;
    
    function initialize() public initializer;
    function getValue() public view returns (uint256);
    function getVersion() public pure returns (uint256); // Returns 2
    function setValue(uint256 newValue) public; // New function
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner;
}
```

## 🧪 Test Coverage

**100% Test Coverage Achieved!** 🎉

| Contract | Lines | Statements | Branches | Functions |
|----------|-------|------------|----------|-----------|
| `src/Box1.sol` | 100.00% (10/10) | 100.00% (5/5) | 100.00% (0/0) | 100.00% (5/5) |
| `src/Box2.sol` | 100.00% (12/12) | 100.00% (6/6) | 100.00% (0/0) | 100.00% (6/6) |

### Test Suite

The comprehensive test suite (`test/DeployAndUpgradeTest.t.sol`) includes:

1. **Basic Functionality Tests**
   - `testUpgrade()` - Tests the upgrade process from Box1 to Box2
   - `testRevertSetValueBeforeUpgrade()` - Ensures Box2 functions don't exist in Box1

2. **Box1 Coverage Tests**
   - `testBox1GetValue()` - Tests the getValue function
   - `testBox1GetVersion()` - Tests the getVersion function
   - `testBox1AuthorizeUpgradeOnlyOwner()` - Tests upgrade authorization

3. **Box2 Coverage Tests**
   - `testBox2Initialize()` - Tests proper initialization of Box2
   - `testBox2AuthorizeUpgradeOnlyOwner()` - Tests upgrade authorization for Box2
   - `testBox2CompleteFlow()` - Tests complete Box2 functionality

## 🚀 Usage

### Build

```shell
forge build
```

### Test

```shell
forge test
```

### Test Coverage

```shell
forge coverage
```

### Deploy Box1

```shell
forge script script/DeployBox.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Upgrade to Box2

```shell
forge script script/UpgradeBox.s.sol --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Gas Snapshots

```shell
forge snapshot
```

### Format Code

```shell
forge fmt
```

## 📁 Project Structure

```
├── src/
│   ├── Box1.sol          # Initial implementation
│   └── Box2.sol          # Upgraded implementation
├── script/
│   ├── DeployBox.s.sol   # Deployment script
│   └── UpgradeBox.s.sol  # Upgrade script
├── test/
│   └── DeployAndUpgradeTest.t.sol  # Comprehensive test suite
└── lib/
    ├── forge-std/
    ├── openzeppelin-contracts/
    └── openzeppelin-contracts-upgradeable/
```

## 🔧 Dependencies

- **Foundry** - Development framework
- **OpenZeppelin Contracts Upgradeable** - Upgradeable contract implementations
- **Foundry DevOps** - Deployment utilities

## 🎯 Key Features

- ✅ **UUPS Pattern**: Gas-efficient upgradeable proxy pattern
- ✅ **Access Control**: Owner-only upgrade authorization
- ✅ **100% Test Coverage**: Comprehensive test suite
- ✅ **Storage Safety**: Proper storage layout preservation during upgrades
- ✅ **Initialization**: Secure contract initialization
- ✅ **DevOps Ready**: Automated deployment and upgrade scripts

## 🛡️ Security Considerations

1. **Upgrade Authorization**: Only the contract owner can authorize upgrades
2. **Initialization Protection**: Contracts use `_disableInitializers()` in constructor
3. **Storage Layout**: Maintains compatibility between contract versions
4. **Access Control**: Implements proper ownership patterns

---

## 📚 Foundry Documentation

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:
- **Forge**: Ethereum testing framework
- **Cast**: Swiss army knife for interacting with EVM smart contracts
- **Anvil**: Local Ethereum node
- **Chisel**: Solidity REPL

### Additional Resources

- [Foundry Book](https://book.getfoundry.sh/)
- [OpenZeppelin Upgrades](https://docs.openzeppelin.com/upgrades-plugins/1.x/)
- [UUPS Pattern](https://eips.ethereum.org/EIPS/eip-1822)
