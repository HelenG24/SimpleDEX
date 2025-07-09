// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title SimpleDEX - Exchange Descentralizado con modelo de producto constante
/// @author Tu Nombre
/// @notice Permite swap entre TokenA y TokenB usando fórmula (x+dx)(y-dy) = xy
contract SimpleDEX is Ownable {
    IERC20 public tokenA;
    IERC20 public tokenB;

    event TokenSwapped(address indexed user, string direction, uint256 amountIn, uint256 amountOut);
    event LiquidityAdded(address indexed provider, uint256 amountTokenA, uint256 amountTokenB);
    event LiquidityRemoved(address indexed to, uint256 amountTokenA, uint256 amountTokenB);

    constructor(address _tokenA, address _tokenB) Ownable(msg.sender) {
        require(_tokenA != address(0) && _tokenB != address(0), "Invalid token address");
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    /// @notice Agrega liquidez al pool (solo owner)
    function addLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA > 0 && amountB > 0, "Amounts must be > 0");

        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        emit LiquidityAdded(msg.sender, amountA, amountB);
    }

    /// @notice Retira liquidez del pool (solo owner)
    function removeLiquidity(uint256 amountA, uint256 amountB) external onlyOwner {
        require(amountA <= tokenA.balanceOf(address(this)), "Not enough TokenA");
        require(amountB <= tokenB.balanceOf(address(this)), "Not enough TokenB");

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        emit LiquidityRemoved(msg.sender, amountA, amountB);
    }

    /// @notice Intercambia TokenA por TokenB usando(x+dx)(y-dy) = xy
    function swapAforB(uint256 amountAIn) external {
        require(amountAIn > 0, "Amount must be > 0");

        uint256 reserveA = tokenA.balanceOf(address(this));
        uint256 reserveB = tokenB.balanceOf(address(this));

        tokenA.transferFrom(msg.sender, address(this), amountAIn);

        uint256 amountBOut = getAmountOut(amountAIn, reserveA, reserveB);
        require(amountBOut > 0 && amountBOut <= reserveB, "Insufficient TokenB");

        tokenB.transfer(msg.sender, amountBOut);

        emit TokenSwapped(msg.sender, "AtoB", amountAIn, amountBOut);
    }

    /// @notice Intercambia TokenB por TokenA usando (x+dx)(y-dy) = xy
    function swapBforA(uint256 amountBIn) external {
        require(amountBIn > 0, "Amount must be > 0");

        uint256 reserveA = tokenA.balanceOf(address(this));
        uint256 reserveB = tokenB.balanceOf(address(this));

        tokenB.transferFrom(msg.sender, address(this), amountBIn);

        uint256 amountAOut = getAmountOut(amountBIn, reserveB, reserveA);
        require(amountAOut > 0 && amountAOut <= reserveA, "Insufficient TokenA");

        tokenA.transfer(msg.sender, amountAOut);

        emit TokenSwapped(msg.sender, "BtoA", amountBIn, amountAOut);
    }

    /// @notice Calcula el precio (output) usando la fórmula (x+dx)(y-dy) = xy
    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) internal pure returns (uint256) {
        require(amountIn > 0, "Invalid input");
        require(reserveIn > 0 && reserveOut > 0, "Empty reserves");

        return (amountIn * reserveOut) / (reserveIn + amountIn);
    }

    /// @notice Obtiene el precio estimado de un token (cuánto vale 1 unidad del token dado en el otro token)
    function getPrice(address _token) external view returns (uint256) {
        uint256 reserveA = tokenA.balanceOf(address(this));
        uint256 reserveB = tokenB.balanceOf(address(this));

        require(reserveA > 0 && reserveB > 0, "No liquidity");

        if (_token == address(tokenA)) {
            return (reserveB * 1e18) / reserveA;
        } else if (_token == address(tokenB)) {
            return (reserveA * 1e18) / reserveB;
        } else {
            revert("Invalid token address");
        }
    }
}
