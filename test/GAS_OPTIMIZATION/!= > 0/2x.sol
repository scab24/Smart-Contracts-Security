// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/forge-std/src/Test.sol";
contract GasTest2x is Test {
    Contract0 c0;
    Contract1 c1;
    Contract2 c2;
    Contract3 c3;
    
    function setUp() public {
        c0 = new Contract0();
        c1 = new Contract1();
        c2 = new Contract2();
        c3 = new Contract3();

    }

    function testGasCode4rena() public view {
        c0.unoptimized1();
        c1.unoptimized2();
        c2.unoptimized3();
        c3.unoptimized4();
    }
}

contract Contract0 {

    function unoptimized1() public pure {
        uint256 a = 2;
        require(a > 0, "!a > 0!");
    }
}

contract Contract1 {

    function unoptimized2() public pure {
        uint256 a = 2;
        require(a != 0, "!a > 0!");
    }
}
contract Contract2 {

    function unoptimized3() public pure {
        uint256 a = 2;
        if(a > 0){}
    }
}

contract Contract3 {

    function unoptimized4() public pure {
        uint256 a = 2;
        if(a != 0){}
    }
}