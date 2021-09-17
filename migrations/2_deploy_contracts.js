const HelloWorld = artifacts.require("HelloWorld");
const Election = artifacts.require("Election");
const User = artifacts.require("User");
module.exports = function (deployer) {
  deployer.deploy(HelloWorld);
  deployer.deploy(Election);
  deployer.deploy(User);
};