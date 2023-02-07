pragma solidity ^0.7.0;
import "lib/forge-std/src/Test.sol";
contract Ownership{

    address owner = msg.sender;

    function Owner() public{
        owner = msg.sender;
    }

    modifier isOwner(){
        require(owner == msg.sender);
        _;
    }
}

contract Pausable is Ownership{

    bool is_paused;

    modifier ifNotPaused(){
        require(!is_paused);
        _;
    }

    function paused() isOwner public{
        is_paused = true;
    }

    function resume() isOwner public{
        is_paused = false;
    }

}

contract Token is Pausable{
    mapping(address => uint) public balances;

    function transfer(address to, uint value) ifNotPaused public{
        balances[msg.sender] -= value;
        balances[to] += value;
    }
}

contract ContractTestOverflowEchidna is Test {
    Token token;
    address bob;
    address alice;

    function setUp() public {
        token = new Token();
        bob = vm.addr(1); 
        alice = vm.addr(2);
    }    
           
    function testFailOverflow() public {
          console.log("Bob balance",token.balances(bob));
          console.log("alice balance", token.balances(alice));


        vm.startPrank(bob); 
        token.transfer(address(alice),107232039821192505912276464474276136537657115717368904133971284);
        console.log("Bob balance",token.balances(bob));
        console.log("alice balance", token.balances(alice));

        vm.stopPrank();
    }
}
