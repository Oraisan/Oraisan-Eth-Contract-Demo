const { ethers } = require("hardhat");
const { expect } = require("chai");

let libAddressManager, LibAddressManager;
let oraisanGate, OraisanGate;

beforeEach(async function () {
  LibAddressManager = await ethers.getContractFactory("AddressManager");
  libAddressManager = await LibAddressManager.deploy();

  OraisanGate = await ethers.getContractFactory("OraisanGate");
  oraisanGate = await OraisanGate.deploy(libAddressManager.address);
});
