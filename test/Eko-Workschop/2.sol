// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    bool useWhiteListSwith;
    mapping(address => bool) msgSenderWhiteList;
    mapping(address => bool) fromWhiteList;
    mapping(address => bool) toWhiteList;

    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 100 ether);
    }

    function transfer(
        address from,
        address to,
        uint256 amount
    ) public {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if(useWhiteListSwith){
            require(msgSenderWhiteList[msg.sender] && fromWhiteList[from]  && toWhiteList[to], "Transfer not allowed");
        }
        _transfer(from, to, amount);
    }
}
