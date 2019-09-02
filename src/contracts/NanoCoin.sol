pragma solidity >=0.4.25 <0.6.0;

// import "./ConvertLib.sol";

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract NanoCoin {
	mapping (address => uint) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

    string name = "NanoCoin";
    string symbol = "NANO";
    uint256 _totalSupply = 1000;

	// address owner = msg.sender;
	address owner = 0x0D969dcf4327e3fd805831A2cD61460045fAf55b;
	address partner = 0x0D6CBff6fbe2b6Df536D3770F5B9FBEf457d2CD3;
	address metamask = 0x27b5419afb9c3D99A262046383e083Ae7d81900a;

	constructor() public {
		balances[owner] = _totalSupply;

		// init();
	}

	// function init() public {
	// }

	modifier onlyOwner(){
		require(msg.sender == owner);
		_;
	}

	function convert(uint amount,uint conversionRate) public pure returns (uint convertedAmount)
	{
		return amount * conversionRate;
	}

	function sendCoin(address sender, address receiver, uint amount) public returns(bool sufficient) {
// 		if (balances[sender] < amount) return false;
		require(balances[sender] > amount);

		balances[sender] -= amount;
		balances[receiver] += amount;
		emit Transfer(sender, receiver, amount);
		return true;
	}

	function sendToOwner(uint amount) public returns (bool sufficient){
		return sendCoin(partner, owner, amount);
	}

	function sendToPartner(uint amount) onlyOwner public returns (bool sufficient){
		return sendCoin(owner, partner, amount);
	}

	function sendToMetaMask(uint amount) onlyOwner public returns (bool sufficient){
		return sendCoin(owner, metamask, amount);
	}

	function getBalanceInEth(address addr) public view returns(uint){
// 		return ConvertLib.convert(getBalance(addr),2);
		return convert(getBalance(addr),2);
	}

	function getBalance(address addr) view public returns(uint) {
		return balances[addr];
	}

	function getOwnerBalance() view public returns (uint){
		return getBalance(owner);
	}

	function getMetaMaskBalance() view public returns (uint){
		return getBalance(metamask);
	}

	function getPartnerBalance() public view returns (uint){
		return getBalance(partner);
	}

	function getOwnerAddress() public view returns (address){
		return owner;
	}

	function getPartnerAddress() public view returns (address){
		return partner;
	}

	function totalSupply() public view returns (uint256){
		return _totalSupply;
	}

// 	function name() public view returns (string){
// 		return _name;
// 	}

// 	function symbol() public view returns (string){
// 		return _symbol;
// 	}

}
