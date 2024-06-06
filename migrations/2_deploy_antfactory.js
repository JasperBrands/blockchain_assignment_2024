const AntFactory = artifacts.require("AntFactory");
const VictoryToken = artifacts.require("VictoryToken");
const AntBattle = artifacts.require("AntBattle");
const AntToken = artifacts.require("AntToken");
const Ownable = artifacts.require("Ownable");

module.exports = function(deployer) {
  deployer.deploy(VictoryToken).then(function() {
    return deployer.deploy(Ownable);
  }).then(function() {
    return deployer.deploy(AntFactory, VictoryToken.address);
  }).then(function() {
    return deployer.deploy(AntBattle, VictoryToken.address);
  }).then(function() {
    return deployer.deploy(AntToken, VictoryToken.address);
  });
};
