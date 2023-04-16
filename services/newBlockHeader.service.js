const { ethers } = require("hardhat");
const dotenv = require("dotenv");
dotenv.config();
const fs = require("fs");
const dataPath = "Data.json";

async function newBlockHeaderService(data) {
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

  let OraisanGate = await ethers.getContractAt(
    "OraisanGate",
    process.env.ORAISAN_GATE
  );

  // let result = await OraisanGate.updateblockHeader(
  //   newBlockData,
  //   newAunts,
  //   newValidators,
  //   newProofs
  // );

  // console.log("newBlockData", newBlockData);
  // console.log("newAunts", newAunts);
  // console.log("newValidators", newValidators);
  // console.log("newProofs", newProofs);

  let CC = await ethers.getContractAt("CC", process.env.CC);
  let result = await CC.ac(newBlockData, newAunts, newValidators, newProofs);
  // let result1 = await CC.blockHeader(newBlockData);
  // let result2 = await CC.blockSibling(newAunts);
  // let result3 = await CC.blockValidator(newValidators);

  // let result5 = await CC.blockProofs(newProofs);

  return 1;
}

newBlockHeaderService("haha");

module.exports = { newBlockHeaderService };
