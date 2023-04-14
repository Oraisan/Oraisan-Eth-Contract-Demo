const { ethers } = require("hardhat");

async function newBlockHeaderService(data) {
  console.log(data);

  return 1;
}

module.exports = { newBlockHeaderService };
