// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

import {Tick} from "./lib/Tick.sol";

contract UniswapV3Pool {

    address public immutable factory;
    address public immutable token0;
    address public immutable token1;
    uint24 public immutable fee;
    int24 public immutable tickSpacing;
    uint128 public immutable maxLiquidityPerTick;

    constructor(address _token0, address _token1, uint24 _fee, int24 _tickSpacing)
    {
           maxLiquidityPerTick = Tick.tickSpacingToMaxLiquidityPerTick(_tickSpacing);
    }

}
