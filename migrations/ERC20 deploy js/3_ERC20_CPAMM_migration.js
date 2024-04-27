// Help Truffle find `CPAMM.sol` in the `/contracts` directory

const ERC20_0 = artifacts.require("ERC20Token0_CPAMM")
const ERC20_1 = artifacts.require("ERC20Token1_CPAMM")
module.exports = function(deployer) {
  // Command Truffle to deploy the Smart Contract
  deployer.deploy(ERC20_0,"TokenA_CPAMM","ACP",18);
  deployer.deploy(ERC20_1,"TokenB_CPAMM","BCP",18);
};

