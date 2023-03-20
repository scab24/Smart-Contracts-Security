// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract WETH is ERC20("Wrapped Ether", "WETH") {
    fallback() external payable {
        deposit();
    }

    function deposit() public payable {
        _mint(msg.sender, msg.value);
    }

    function withdraw(uint256 wad) external {
        (bool success,) = msg.sender.call{value: wad}("");
        require(success, "withdraw failed");
        _burn(msg.sender, wad);
    }

    function withdrawAll() external {
        (bool success,) = msg.sender.call{value: balanceOf(msg.sender)}("");
        require(success, "withdraw failed");
        _burn(msg.sender, balanceOf(msg.sender));
    }
}