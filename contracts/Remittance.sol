pragma solidity 0.4.13;

contract Remittance {
    struct Exchange {
        address sender;
        address escrow;
        uint256 amount;
    }

    address internal owner;
    mapping(bytes32 => Exchange) public exchanges;
    mapping(bytes32 => bool) public passUsed;

	function Remittance() {
        owner = msg.owner;
	}

	function initExchange(address escrow, bytes32 passHash) payable {
        require(msg.value > 0);
        require(!passUsed[passHash]);
        require(exchanges[passHash].amount == 0);

        exchanges[passHash] = Exchange(msg.sender, escrow, msg.value);
	}

    function payout(string password) {
        bytes32 passHash = keccak256(password);

        ex = exchanges[passHash];
        uint256 amountToSend = ex.amount;
        address toWhom = ex.escrow;

        require(amountToSend > 0);
        require(toWhom == msg.sender);

        passUsed[passHash] = true;
        delete exchanges[passHash];

        toWhom.transfer(amountToSend);
    }
}
