// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSwap {
    address public owner;
    IERC20 public tokenA;
    IERC20 public tokenB;

    event TokensSwapped(address indexed swapper, uint256 amountA, uint256 amountB);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(address _tokenA, address _tokenB) {
        owner = msg.sender;
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

function swapTokens(uint256 _amountA, uint256 _amountB) external {
        require(_amountA > 0 && _amountB > 0, "Amounts must be greater than 0");

        // Transfer tokens from the swapper to the contract
        require(tokenA.transferFrom(msg.sender, address(this), _amountA), "TokenA transfer failed");
        require(tokenB.transferFrom(msg.sender, address(this), _amountB), "TokenB transfer failed");

        // Swap tokens between the swapper and the contract
        require(tokenA.transfer(msg.sender, _amountB), "TokenA transfer failed");
        require(tokenB.transfer(msg.sender, _amountA), "TokenB transfer failed");

        emit TokensSwapped(msg.sender, _amountA, _amountB);
    }

function withdrawTokens(address _token, uint256 _amount) external onlyOwner {
        require(_token == address(tokenA) || _token == address(tokenB), "Invalid token address");
        require(IERC20(_token).transfer(owner, _amount), "Token transfer failed");
    }

}
