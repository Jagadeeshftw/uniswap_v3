// SPDX-License-Identifier: MIT

pragma solidity >=0.8.19;

import {Tick} from "./lib/Tick.sol";
import {TickMath} from "./lib/TickMath.sol";

contract UniswapV3Pool {
    address public immutable factory;
    address public immutable token0;
    address public immutable token1;
    uint24 public immutable fee;
    int24 public immutable tickSpacing;
    uint128 public immutable maxLiquidityPerTick;

    struct Slot0 {
        // the current price
        uint160 sqrtPriceX96;
        // the current tick
        int24 tick;
        // whether the pool is locked
        bool unlocked;
    }

    Slot0 public slot0;

    constructor(address _token0, address _token1, uint24 _fee, int24 _tickSpacing) {
        maxLiquidityPerTick = Tick.tickSpacingToMaxLiquidityPerTick(_tickSpacing);
    }

    /// @dev not locked because it initializes unlocked
    function initialize(uint160 sqrtPriceX96) external {
        require(slot0.sqrtPriceX96 == 0, "AI");

        int24 tick = TickMath.getTickAtSqrtRatio(sqrtPriceX96);

        slot0 = Slot0({sqrtPriceX96: sqrtPriceX96, tick: tick, unlocked: true});
    }
}
