// SPDX-License-Identifier: BUSL-1.1

/**
 * @title Portfolio
 * @author Velvet.Capital
 * @notice Serves as the primary interface for users to interact with the portfolio, allowing deposits and withdrawals.
 * @dev Integrates with multiple modules to provide a comprehensive solution for portfolio fund management, including asset management,
 *      protocol configuration, and fee handling. Supports upgradeability through UUPS pattern.
 */
pragma solidity 0.8.17;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable-4.9.6/access/OwnableUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable-4.9.6/proxy/utils/UUPSUpgradeable.sol";
import {IAssetManagementConfig} from "../config/assetManagement/IAssetManagementConfig.sol";
import {IProtocolConfig} from "../config/protocol/IProtocolConfig.sol";
import {IFeeModule} from "../fee/IFeeModule.sol";
import {VaultManager, Dependencies} from "./management/VaultManager.sol";
import {FunctionParameters} from "../FunctionParameters.sol";

contract Portfolio is OwnableUpgradeable, UUPSUpgradeable, VaultManager {
  // Configuration contracts for asset management, protocol parameters, and fee calculations.
  IAssetManagementConfig private _assetManagementConfig;
  IFeeModule private _feeModule;

  // Prevents the constructor from being called on the implementation contract, ensuring only proxy initialization is valid.
  constructor() {
    _disableInitializers();
  }

  /**
   * @notice Initializes the portfolio contract with necessary configurations.
   * @param initData Struct containing all necessary initialization parameters including asset management, protocol config, and fee module addresses.
   */
  function init(
    FunctionParameters.PortfolioInitData calldata initData
  ) external initializer {
    __Ownable_init();
    __UUPSUpgradeable_init();

    // Initializes configurations for vault management, token settings, access controls, and user management.
    __VaultConfig_init(initData._vault, initData._module);
    __PortfolioToken_init(initData._name, initData._symbol);
    __VaultManager_init(initData._protocolConfig, initData._borrowManager);
    __AccessModifiers_init(initData._accessController);
    __UserManagement_init(initData._tokenExclusionManager);

    // Sets up the contracts for managing assets, protocol parameters, and fee calculations.
    _assetManagementConfig = IAssetManagementConfig(
      initData._assetManagementConfig
    );
    _feeModule = IFeeModule(initData._feeModule);
  }

  // Provides a way to retrieve the asset management configuration.
  function assetManagementConfig()
    public
    view
    override(Dependencies)
    returns (IAssetManagementConfig)
  {
    return _assetManagementConfig;
  }

  // Provides a way to retrieve the protocol configuration.
  function protocolConfig()
    public
    view
    override(Dependencies)
    returns (IProtocolConfig)
  {
    return _protocolConfig;
  }

  // Provides a way to retrieve the fee module.
  function feeModule() public view override(Dependencies) returns (IFeeModule) {
    return _feeModule;
  }

  /**
   * @notice Authorizes the smart contract upgrade to a new implementation.
   * @dev Ensures that only the contract owner can perform the upgrade.
   * @param newImplementation The address of the new contract implementation.
   */
  function _authorizeUpgrade(
    address newImplementation
  ) internal override onlyOwner {
    // Intentionally left empty as required by an abstract contract
  }
}
