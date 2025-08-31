// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {IMiniAMM, IMiniAMMEvents} from "./IMiniAMM.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// Add as many variables or functions as you would like
// for the implementation. The goal is to pass `forge test`.
contract MiniAMM is IMiniAMM, IMiniAMMEvents {
    uint256 public k = 0;
    uint256 public xReserve = 0;
    uint256 public yReserve = 0;

    address public tokenX;
    address public tokenY;

    // implement constructor
    constructor(address _tokenX, address _tokenY) {
        require(_tokenX != address(0), "tokenX cannot be zero address");
        require(_tokenY != address(0), "tokenY cannot be zero address");

        require(_tokenX != _tokenY, "Tokens must be different");

        // _tokenX가 더 작은거, _tokenY가 더 큰 걸로 지정해야한다.
        if (_tokenX < _tokenY) {
            tokenX = _tokenX;
            tokenY = _tokenY;
        } else {
            tokenX = _tokenY;
            tokenY = _tokenX;
        }
    }

    // add parameters and implement function.
    // this function will determine the initial 'k'.
    function _addLiquidityFirstTime(
        uint256 xAmountIn,
        uint256 yAmountIn
    ) internal {
        //sender의 지갑에서 x와 y를 각각 뺴온다.
        IERC20(tokenX).transferFrom(msg.sender, address(this), xAmountIn);
        IERC20(tokenY).transferFrom(msg.sender, address(this), yAmountIn);

        //miniAMM에 넣는다.
        xReserve += xAmountIn;
        yReserve += yAmountIn;

        //k를 x*y로 설정한다.
        k = xReserve * yReserve;
    }

    // add parameters and implement function.
    // this function will increase the 'k'
    // because it is transferring liquidity from users to this contract.
    function _addLiquidityNotFirstTime(
        uint256 xDelta,
        uint256 yRequired
    ) internal {
        //sender의 지갑에서 x와 y를 각각 뺴온다.
        IERC20(tokenX).transferFrom(msg.sender, address(this), xDelta);
        IERC20(tokenY).transferFrom(msg.sender, address(this), yRequired);

        //miniAMM에 넣는다.
        xReserve += xDelta;
        yReserve += yRequired;

        k = xReserve * yReserve;
    }

    // complete the function
    function addLiquidity(uint256 xAmountIn, uint256 yAmountIn) external {
        require(
            (xAmountIn != 0) && (yAmountIn != 0),
            "Amounts must be greater than 0"
        );

        if (k == 0) {
            // add params
            _addLiquidityFirstTime(xAmountIn, yAmountIn);
        } else {
            // add params
            _addLiquidityNotFirstTime(xAmountIn, yAmountIn);
        }
    }

    // complete the function
    function swap(uint256 xAmountIn, uint256 yAmountIn) external {
        require(k != 0, "No liquidity in pool");

        require(
            !(xAmountIn == 0 && yAmountIn == 0),
            "Must swap at least one token"
        );

        require(
            (xAmountIn != 0 && yAmountIn == 0) ||
                (yAmountIn != 0 && xAmountIn == 0),
            "Can only swap one direction at a time"
        );

        require(
            (xAmountIn <= xReserve) && (yAmountIn <= yReserve),
            "Insufficient liquidity"
        );

        if (xAmountIn == 0) {
            uint xRequired = xReserve - (k / (yReserve + yAmountIn));

            yReserve += yAmountIn;
            xReserve -= xRequired;

            IERC20(tokenY).transferFrom(msg.sender, address(this), yAmountIn);
            IERC20(tokenX).transfer(msg.sender, xRequired);
        } else if (yAmountIn == 0) {
            uint256 yRequired = yReserve - (k / (xReserve + xAmountIn));

            xReserve += xAmountIn;
            yReserve -= yRequired;

            IERC20(tokenX).transferFrom(msg.sender, address(this), xAmountIn);
            IERC20(tokenY).transfer(msg.sender, yRequired);
        }
    }
}
