import "./token.sol";

contract MintableToken is Token{

    int public totalMinted;
    int public totalMintable;

    constructor(int _totalMintable) public {
        totalMintable = _totalMintable;
    }

    function mint(uint value) isOwner() public {

        require(int(value) + totalMinted < totalMintable);
        totalMinted += int(value);

        balances[msg.sender] += value;
     
    }

}
