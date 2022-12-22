// Help Truffle find `TruffleTutorial.sol` in the `/contracts` directory
const PropertyOwnership = artifacts.require("PropertyOwnership");

module.exports = function(deployer) {
  // Command Truffle to deploy the Smart Contract
  deployer.deploy(PropertyOwnership, '0x7b020011454C50B17b6fCe8fF5E1224f923AfBAA');
};