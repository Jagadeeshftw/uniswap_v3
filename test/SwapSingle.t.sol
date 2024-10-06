// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.5;
pragma abicoder v2;

import {ISwapRouter} from'../src/interfaces/ISwapRouter.sol';
import {IERC20} from "../src/interfaces/IERC20.sol";
import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";

contract SwapSingle is Test{

    ISwapRouter public immutable swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;
    
    address public anvil_account1;

        function setUp() public {
        anvil_account1 = address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        console.log("the balance of DAI:", IERC20(DAI).balanceOf(anvil_account1)/1e18);

        deal(DAI, anvil_account1, 10000 * 1e18, true);

        console.log("the balance of DAI:", IERC20(DAI).balanceOf(anvil_account1)/1e18);
        vm.prank(anvil_account1);
        IERC20(DAI).approve(address(swapRouter), type(uint256).max);

    }

    function test_swapExactInputSingle() public {

        uint256 amountIn = 100 * 1e18;
        ISwapRouter.ExactInputSingleParams memory params =
            ISwapRouter.ExactInputSingleParams({
                tokenIn: DAI,
                tokenOut: WETH9,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        // The call to `exactInputSingle` executes the swap.
        vm.prank(anvil_account1);
        uint256 amountOut = swapRouter.exactInputSingle(params);
        console.log("The amountOut:", amountOut/1e18);

        vm.prank(anvil_account1);
        IERC20(DAI).approve(address(swapRouter), 0);
    }

    function test_swapExactOutputSingle() external returns (uint256 amountIn) {
        uint256 amountOut = 1 * 1e18;
        uint256 amountInMaximum = 5000 * 1e18;

        ISwapRouter.ExactOutputSingleParams memory params =
            ISwapRouter.ExactOutputSingleParams({
                tokenIn: DAI,
                tokenOut: WETH9,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            });
        vm.prank(anvil_account1);
        // Executes the swap returning the amountIn needed to spend to receive the desired amountOut.
        amountIn = swapRouter.exactOutputSingle(params);
        console.log("The amountIn:", amountIn/1e18);
        // For exact output swaps, the amountInMaximum may not have all been spent.

        vm.prank(anvil_account1);
        IERC20(DAI).approve(address(swapRouter), 0);

    }
}