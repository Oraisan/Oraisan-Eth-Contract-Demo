const { ethers } = require("hardhat");
const { expect } = require("chai");

let verify, Verify;
let helper, Helper;

const proof = {
  Total: 2,
  Index: 0,
  LeafHash:
    "0xb22d4be7985f0277aa0472866169b31a8d7216462114fc7df5ef548a4566e201",
  Aunts: ["0x93251b6bf446e81c3aa68274e1223dac0ecf3c7ceeae6dd78e57d3d845151987"],
};
const rootHash =
  "0x677bf175de9c1eddd2f26ae4161631390a24486d44bbc71982c39965f58967c4";
const leaf =
  "0xCD5EEB8E8140C15D0127A06706D1DEFFE0139335FD9BA7C1CAC1143F5AC61059";

beforeEach(async function () {
  Helper = await ethers.getContractFactory("Helper");
  helper = await Helper.deploy();
  await helper.deployed();

  Verify = await ethers.getContractFactory("Verify", {
    libraries: { Helper: helper.address },
  });

  verify = await Verify.deploy();
  await verify.deployed();
});

describe("IAVL", function () {
  it("Should return the right value", async function () {
    console.log("verify.address", verify.address);
    const result = await verify.verify(proof, rootHash, leaf);
    console.log("result", result);
  });
});
