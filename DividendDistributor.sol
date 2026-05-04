// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract DividendDistributor is ReentrancyGuard {
    IERC20 public dividendToken;
    IERC20 public assetToken;
    
    uint256 public totalDividendsDistributed;
    mapping(address => uint256) public dividendsClaimed;
    uint256 private _dividendPerShare;

    constructor(address _assetToken, address _dividendToken) {
        assetToken = IERC20(_assetToken);
        dividendToken = IERC20(_dividendToken);
    }

    function distribute(uint256 amount) external {
        dividendToken.transferFrom(msg.sender, address(this), amount);
        _dividendPerShare += (amount * 1e18) / assetToken.totalSupply();
        totalDividendsDistributed += amount;
    }

    function claim() external nonReentrant {
        uint256 balance = assetToken.balanceOf(msg.sender);
        uint256 amount = (balance * _dividendPerShare) / 1e18 - dividendsClaimed[msg.sender];
        
        require(amount > 0, "Nothing to claim");
        dividendsClaimed[msg.sender] += amount;
        dividendToken.transfer(msg.sender, amount);
    }
}
