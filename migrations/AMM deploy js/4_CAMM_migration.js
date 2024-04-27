// Help Truffle find `CAMM.sol` in the `/contracts` directory

const CAMM = artifacts.require("CAMM")
module.exports = function(deployer) {
  // Command Truffle to deploy the Smart Contract
  const TokenA_addr_CAMM = "";
  const TokenB_addr_CAMM = "";
  deployer.deploy(CAMM,TokenA_addr_CAMM,TokenB_addr_CAMM);
};

