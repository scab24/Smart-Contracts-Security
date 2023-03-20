// SPDX-License-Identifier: MIT
pragma solidity ^0.4.23;

contract WalletLib {
    // NOTE: storage layout must be the same as contract Wallet
    address public walletLib;
    address public owner;

    function initWallet() {
        owner = msg.sender;
    }

    function withdraw(address to, uint256 amount) {
        require(msg.sender==owner, "!owner");
        to.send(amount);
    }

}

contract Wallet {
    address public walletLib;
    address public owner;

    event Deposit(address user, uint256 amount);

    function Wallet() {
        walletLib = new WalletLib();
        // A's storage is set, B is not modified.
        walletLib.delegatecall(
            abi.encodeWithSignature("initWallet()")
        );
    }

    function withdraw(address to, uint256 amount) external {
        walletLib.delegatecall(msg.data, amount);
    }

    // gets called when no other function matches
    function() payable {
        // just being sent some cash?
        if (msg.value > 0)
            Deposit(msg.sender, msg.value);
        else if (msg.data.length > 0)
            walletLib.delegatecall(msg.data);
    }
}