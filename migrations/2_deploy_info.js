var InfoContract = artifacts.require("./InfoContract.sol");

module.exports = function(deployer) {
  deployer.deploy(InfoContract);
};
