// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;
import "@openzeppelin/contracts-5.0.2/token/ERC20/IERC20.sol";


interface IMetaAggregatorSwapContract {
    function swapERC20(
        IERC20 tokenIn,
        IERC20 tokenOut,
        address aggregator,
        bytes calldata swapData,
        uint256 amountIn,
        uint256 minAmountOut,
        address receiver,
        bool isDelegate
    ) external;

    function swapETH(
        IERC20 tokenIn,
        IERC20 tokenOut,
        address aggregator,
        bytes calldata swapData,
        uint256 amountIn,
        uint256 minAmountOut,
        address receiver,
        bool isDelegate
    ) external payable;
}