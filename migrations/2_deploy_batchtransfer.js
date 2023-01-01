var BatchTransfer = artifacts.require("BatchTransfer");

module.exports = function(deployer) {
    deployer.deploy(BatchTransfer);
    // Additional contracts can be deployed here
};
