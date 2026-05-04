// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IComplianceRegistry {
    function isVerified(address account) external view returns (bool);
}

contract AssetToken is ERC20, Ownable {
    IComplianceRegistry public registry;
    string public legalDocumentURI;

    constructor(
        string memory name, 
        string memory symbol, 
        address _registry,
        string memory _docURI
    ) ERC20(name, symbol) Ownable(msg.sender) {
        registry = IComplianceRegistry(_registry);
        legalDocumentURI = _docURI;
    }

    function _update(address from, address to, uint256 value) internal override {
        if (from != address(0) && to != address(0)) {
            require(registry.isVerified(from), "Sender not compliant");
            require(registry.isVerified(to), "Recipient not compliant");
        }
        super._update(from, to, value);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        require(registry.isVerified(to), "Recipient must be verified");
        _mint(to, amount);
    }
}
