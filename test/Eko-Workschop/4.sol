// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    address owner;
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 100 ether);
    }

    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }
}