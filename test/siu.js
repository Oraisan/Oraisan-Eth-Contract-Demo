const { ethers, upgrades } = require("hardhat");
require("dotenv").config();
const fs = require("fs");
const dataPath = "Data.json";

let oraisanGate, OraisanGate;
let lib_AddressManager, Lib_AddressManager;

beforeEach(async () => {
  Lib_AddressManager = await ethers.getContractFactory("Lib_AddressManager");
  lib_AddressManager = await upgrades.deployProxy(Lib_AddressManager, []);

  await lib_AddressManager.deployed();

  OraisanGate = await ethers.getContractFactory("OraisanGate");
  oraisanGate = await upgrades.deployProxy(OraisanGate, [
    lib_AddressManager.address,
  ]);
  await oraisanGate.deployed();
});

describe("OraisanGate", function () {
  it("Should return the new greeting once it's changed", async function () {
    const dataObj = JSON.parse(fs.readFileSync(dataPath));
    let { newBlockData, authProofs, validatorData, aunts } = dataObj;

    newBlockData = {
      height: parseInt(newBlockData.height),
      blockHash: "0x" + newBlockData.blockHash,
      blockTime: ethers.BigNumber.from(newBlockData.blockTime),
      dataHash: "0x" + newBlockData.dataHash,
      validatorHash: "0x" + newBlockData.validatorsHash,
    };
    // console.log("newBlockData", newBlockData);

    newAunts = [];
    for (let i = 0; i < aunts.length; i++) {
      newAunts.push("0x" + aunts[i]);
    }

    const newValidators = [];
    for (let i = 0; i < validatorData.length; i++) {
      let vl = [
        "0x" + Buffer.from(validatorData[i].pub_key, "base64").toString("hex"),
        parseInt(validatorData[i].voting_power),
      ];
      newValidators.push(vl);
    }

    // console.log("authProofs", authProofs);
    const newProofs = [];

    authProofs.map((proof) => {
      let pubkeysBytes = Buffer.from(proof.pubkeys, "hex");
      let pubkeys = Array.from(new Uint8Array(pubkeysBytes));

      let newProof = [
        proof.optionName,
        proof.oldIndex,
        proof.newIndex,
        proof.pi_a,
        proof.pi_b,
        proof.pi_c,
        pubkeys,
        proof.R8,
        proof.S,
      ];
      newProofs.push(newProof);
    });

    let result = await oraisanGate.updateblockHeader(
      newBlockData,
      newAunts,
      newValidators,
      newProofs
    );

    console.log("result", result);
  });
});
