// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.26;

/// @notice Align ETH into OP burn.
contract OPA {
    address constant WETH = 0x4200000000000000000000000000000000000006;
    address constant OP = 0x4200000000000000000000000000000000000042;
    address constant POOL = 0x68F5C0A2DE713a54991E01858Fd27a3832401849;
    uint160 constant MIN_SQRT_RATIO_PLUS_ONE = 4295128740;

    function align() public payable {
        (, int256 op) =
            IAlign(POOL).swap(address(this), true, int256(msg.value), MIN_SQRT_RATIO_PLUS_ONE, "");
        IAlign(OP).burn(uint256(-(op)));
    }

    /// @dev `uniswapV3SwapCallback`.
    fallback() external payable {
        assembly ("memory-safe") {
            let amount0Delta := calldataload(0x4)
            if iszero(eq(caller(), POOL)) { revert(codesize(), 0x00) }
            pop(call(gas(), WETH, amount0Delta, codesize(), 0x00, codesize(), 0x00))
            mstore(0x14, POOL)
            mstore(0x34, amount0Delta)
            mstore(0x00, 0xa9059cbb000000000000000000000000)
            pop(call(gas(), WETH, 0, 0x10, 0x44, codesize(), 0x00))
            mstore(0x34, 0)
        }
    }

    receive() external payable {
        align();
    }
}

interface IAlign {
    function burn(uint256) external;

    function swap(address, bool, int256, uint160, bytes calldata)
        external
        returns (int256, int256);
}
