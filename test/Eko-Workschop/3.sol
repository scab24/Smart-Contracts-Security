// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 100 ether);
    }

    //
    // "burnable"
    //
    function burn(uint256 amount) external {
        require(balanceOf(msg.sender) >= amount, "ERROR_BTL");
        _burn(msg.sender, amount);
    }

    function burnFrom(address from, uint256 amount) external {
        require(allowance(msg.sender, from) >= amount, "ERROR_ATL");
        require(balanceOf(from) >= amount, "ERROR_BTL");
        _approve(msg.sender, from, allowance(msg.sender, from) - amount);
        _burn(from, amount);
    }
}