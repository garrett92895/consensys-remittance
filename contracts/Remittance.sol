pragma solidity 0.4.13;

contract Remittance {
    struct Exchange {
        address receiver;
        uint256 amount;
    }

    address internal owner;
    mapping(bytes32 => Exchange) public exchanges;
    mapping(bytes32 => bool) public passUsed;

	function Remittance()
    {
        owner = msg.sender;
	}

	function initExchange(address receiver, bytes32 passHash)
      payable 
      public
    {
        require(msg.value > 0);
        require(!passUsed[passHash]);
        require(exchanges[passHash].amount == 0);

        exchanges[passHash] = Exchange(receiver, msg.value);
	}

    function payout(string password)
      public
    {
        bytes32 passHash = keccak256(password);

        Exchange exchange = exchanges[passHash];
        uint256 amountToSend = exchange.amount;
        address toWhom = exchange.receiver;

        require(amountToSend > 0);
        require(toWhom == msg.sender);

        passUsed[passHash] = true;
        delete exchanges[passHash];

        toWhom.transfer(amountToSend);
    }
}
