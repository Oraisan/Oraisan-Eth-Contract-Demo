const { ethers } = require("hardhat");
const { expect } = require("chai");

let verify, Verify;
let helper, Helper;

// data test for tx
const proofTx = {
  Total: 2,
  Index: 0,
  LeafHash:
    "0xb22d4be7985f0277aa0472866169b31a8d7216462114fc7df5ef548a4566e201",
  Aunts: ["0x93251b6bf446e81c3aa68274e1223dac0ecf3c7ceeae6dd78e57d3d845151987"],
};
const rootHashTx =
  "0x677bf175de9c1eddd2f26ae4161631390a24486d44bbc71982c39965f58967c4";
const leafTx =
  "0xCD5EEB8E8140C15D0127A06706D1DEFFE0139335FD9BA7C1CAC1143F5AC61059";

// data test for data [hash in block header

const proofDataHash = {
  Total: 14,
  Index: 6,
  LeafHash:
    "0x47d8cf257fc42801a8e300577230cc3b45207110eeb7724f57e3f1ba5c828502",
  Aunts: [
    "0x8A301484E30737BBB11F409421839213A6CD5A2BBEB27C51464CB893A999DDC7",
    "0x3110DB763FAC7DB275B7A82CF0F69EA4BA83281C690FE3851F29C5DB5F1AE086",
    "0x1B3B374D2E98278E34B808FB9B61ED4BEA528A41DE20DC2D2154DB4B06872AC1",
    "0x021BAC303EB2E23EC3D446693449C5CA92E430EFEC8EE569C700B03A3B746A7D",
  ],
};
const rootHashDataHash =
  "0xd76e82f31e67856b51f9eb02f1ffffaffa53fb14a0de70c4325e282aecf65648";
const leafDataHash =
  "0x0a4036373742463137354445394331454444443246323641453431363136333133393041323434383644343442424337313938324333393936354635383936374334";

// test
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
  it("verify tx in data hash", async function () {
    console.log("verify.address", verify.address);
    const result = await verify.verify(proofTx, rootHashTx, leafTx);
    console.log("result", result);
  });
  it("verify data hash in block header", async function () {
    console.log("verify.address", verify.address);
    const result = await verify.verify(
      proofDataHash,
      rootHashDataHash,
      leafDataHash
    );
    console.log("result", result);
  });
});
