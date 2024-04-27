// Help Truffle find `CPAMM.sol` in the `/contracts` directory

const CPAMM = artifacts.require("CPAMM")
module.exports = function(deployer) {
  // Command Truffle to deploy the Smart Contract
  const TokenA_addr_CPAMM = "";
  const TokenB_addr_CPAMM = "";

  deployer.deploy(CPAMM,TokenA_addr_CPAMM,TokenB_addr_CPAMM);
};

