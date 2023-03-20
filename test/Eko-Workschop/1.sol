// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address owner;
    constructor() ERC20("MyToken", "MTK") {
        owner = msg.sender;
    }

    modifier onlyOwner {
        owner == msg.sender;
        _;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
} 