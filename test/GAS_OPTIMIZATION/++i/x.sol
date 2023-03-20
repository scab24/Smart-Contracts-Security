// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "lib/forge-std/src/Test.sol";
contract GasTestExample is Test {
    Contract0 c0;
    Contract1 c1;
    Contract2 c2;

    function setUp() public {
        c0 = new Contract0();
        c1 = new Contract1();
        c2 = new Contract2();
    }

    function testGasCode4rena() public view {
        c0.unoptimized1();
        c1.unoptimized2();
        c2.optimized();
    }
}

contract Contract0 {

    function unoptimized1() public pure {

        for (uint256 i = 0; i < 10; i++) {
        }
    }
}

contract Contract1 {

    function unoptimized2() public pure {

        for (uint256 i = 0; i < 10; ++i) {
        }
    }
}

contract Contract2 {
    function optimized() public pure {

        for (uint256 i; i < 10; ) {
	    unchecked{++i;}
        }
    }
}
