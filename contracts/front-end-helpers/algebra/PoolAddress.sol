// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.17;

/// @title Provides functions for deriving a pool address from the poolDeployer and tokens
/// @dev Credit to Uniswap Labs under GPL-2.0-or-later license:
/// https://github.com/Uniswap/v3-periphery
library PoolAddress {
  bytes32 internal constant POOL_INIT_CODE_HASH =
    0x4b9e4a8044ce5695e06fce9421a63b6f5c3db8a561eebb30ea4c775469e36eaf;

  /// @notice The identifying key of the pool
  struct PoolKey {
    address deployer;
    address token0;
    address token1;
  }

  /// @notice Returns PoolKey: the ordered tokens
  /// @param deployer The custom pool deployer address
  /// @param tokenA The first token of a pool, unsorted
  /// @param tokenB The second token of a pool, unsorted
  /// @return Poolkey The pool details with ordered token0 and token1 assignments
  function getPoolKey(
    address deployer,
    address tokenA,
    address tokenB
  ) internal pure returns (PoolKey memory) {
    if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
    return PoolKey({ deployer: deployer, token0: tokenA, token1: tokenB });
  }

  /// @notice Deterministically computes the pool address given the poolDeployer and PoolKey
  /// @param poolDeployer The Algebra poolDeployer contract address
  /// @param key The PoolKey
  /// @return pool The contract address of the Algebra pool
  function computeAddress(
    address poolDeployer,
    PoolKey memory key
  ) internal pure returns (address pool) {
    require(key.token0 < key.token1, "Invalid order of tokens");
    pool = address(
      uint160(
        uint256(
          keccak256(
            abi.encodePacked(
              hex"ff",
              poolDeployer,
              keccak256(
                key.deployer == address(0)
                  ? abi.encode(key.token0, key.token1)
                  : abi.encode(key.deployer, key.token0, key.token1)
              ),
              POOL_INIT_CODE_HASH
            )
          )
        )
      )
    );
  }
}
