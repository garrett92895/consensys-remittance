const Remittance = artifacts.require("./Remittance.sol");

let BigNumber = web3.BigNumber;

contract("Remittance test: ", accounts => {
    let contract;
    const amountToSend = new BigNumber(web3.toWei(1, "ether"));
    const password = "consensys";
    const passHash = web3.sha3(password);
    const zeroAddress = "0x" + new Array(41).join("0")

    before(() => {
        return Remittance.deployed().then(instance => contract = instance);
    });

    it("Test initExchange", () => {
        return contract.initExchange(accounts[2], passHash, {from: accounts[1], value: amountToSend})
        .then(() => contract.exchanges(passHash))
        .then(exchange => {
            assert.equal(exchange[0], accounts[2], "Exchange receiver incorrect");
            assert.isTrue(amountToSend.equals(exchange[1]), "Amount incorrect");   
        })
    });

    it("Test payout", () => {
        return contract.payout(password, {from: accounts[2]})
        .then(() => contract.passUsed(passHash))
        .then(passUsed => assert.isTrue(passUsed))
        .then(() => contract.exchanges(passHash))
        .then(exchange => {
            assert.equal(zeroAddress, exchange[0], "Exchange address not reset");
            assert.isTrue(new BigNumber(0).equals(exchange[1]), "Exchange amount not emptied");
        });
    });
})
