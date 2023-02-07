// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "lib/forge-std/src/Test.sol";

import "./mintable.sol";

contract TestExerciseEchidna3 is Test {
    MintableToken mintableToken;
    address juan;
    address alice;

    
    function setUp() public { 

        juan = vm.addr(1);
        alice = vm.addr(2);
    }

    function testMint() public {
        vm.prank(juan);
        mintableToken = new MintableToken(10000);

        vm.prank(juan);
        mintableToken.mint(96630461827592406824117123399527024486325951824057926638922394187655300856523); 
    

        vm.prank(juan);
        mintableToken.transfer(address(alice),1524785991);

        
 
    }
}