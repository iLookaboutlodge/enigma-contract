const EnigmaToken = artifacts.require("EnigmaToken.sol");
const Enigma = artifacts.require("Enigma.sol");
const CoinMixer = artifacts.require("CoinMixer.sol");
const Billionare = artifacts.require("Billionare.sol");
const MillionairesProblemFactory = artifacts.require(
    "MillionairesProblemFactory.sol"
);
const data = require("../test/data");

module.exports = function(deployer) {
    return deployer
        .then(() => {
            return deployer.deploy(EnigmaToken, { overwrite: false });
        })
        .then(() => {
            return web3.eth.getAccounts();
        })
        .then(accounts => {
            // Setting the principal node to the first signer address in the data file
            const principal = data.principal[0];
            console.log("using account", principal, "as principal signer");
            return deployer.deploy(Enigma, EnigmaToken.address, principal, {
                overwrite: false
            });
        })
        .then(() => {
            return deployer.deploy(MillionairesProblemFactory, Enigma.address);
        })
        .then(() => {
            return deployer.deploy(CoinMixer, Enigma.address);
        })
        .then(() => {
            return deployer.deploy(Billionare);
        });
};
