const CryptoMessage = artifacts.require("CryptoMessage");

module.exports = function (deployer) {
  deployer.deploy(CryptoMessage);
};
