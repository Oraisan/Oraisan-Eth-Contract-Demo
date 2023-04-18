const { ethers, upgrades } = require("hardhat");
require("dotenv").config();
const fs = require("fs");
const dataPath = "Data.json";

const input = {
  lib_AddressManager: process.env.Lib_AddressManager,
  currentHeight: 10340037,
  numValidator: 46,
  validatorSet: [
    [
      "0xfd284e309e23a18641a8f545b43d3eb24539f65061f38b80c8b92678be83a70a",
      200159,
    ],
    [
      "0x88cbd767eced2f5681039a1102f071bc94c1354646828aaa44af884c632e8699",
      196523,
    ],
    [
      "0x14ab83d3cf66cf866a372588774214cccb1d6649f290281214bb9ffce9d5d618",
      195252,
    ],
    [
      "0x7f005420f6a0bdc38a87877a763bda63a0672cf4e3390b1f366b49dd11ae2f32",
      189806,
    ],
    [
      "0x8cbba779efbeefef6d3b4bd52011b9f4f386c246d284688e59bb6081364c8cc3",
      185263,
    ],
    [
      "0x18d6690f831ba4a8330d1484414fcbe37f29730203cb038db3fe949e9860e0c9",
      171954,
    ],
    [
      "0x68fa9b866003b2b4815c3f6a80b769b1332aa1467bcd9b9fc112bb2fe1b41d5f",
      171248,
    ],
    [
      "0x6c93d978f2a4373cf757f58005e1cf55d9a7e0693ab876ead53a2ba3beaee124",
      170876,
    ],
    [
      "0x75d397c7f078a2fdefdd0c3d80fb0f0a8383c51a84634e580496deafdc1b415f",
      167851,
    ],
    [
      "0x597a914a043489be13a078e873cc5a2f2d720c1fe264134259940a60d4600d5a",
      167751,
    ],
    [
      "0x167bb94d517dc18fd9de51e5b74ad367a43a3429cd4e82a7b29ccc74418424ef",
      166829,
    ],
    [
      "0x2da151e3f06e0b7310b176360959e6bcc24bff5b6ac99b33cc4b620ce63f2788",
      166590,
    ],
    [
      "0x534b885a699b2b4d00d9f9ac5d58b66ee1b17d5697ec719a684f702141072a9a",
      166001,
    ],
    [
      "0x8d3cfd73677e04d7573ce200226805a0e8b83de33d90cf8c6da40f4dc66c1ae4",
      163828,
    ],
    [
      "0x4eacda9601e52c14fa17dc3f3a546f996c9d589f27a4743f9b589ad6ed4976e0",
      160759,
    ],
    [
      "0xb1f95da9d8b240ea813f8a05f23d9d2bc2613d34a23c8c9fe1a170959c3961a6",
      160448,
    ],
    [
      "0x021c61b6baa5609bac15ac9ef270d9110952e841ee68ad4135bf0e47502dfb55",
      159180,
    ],
    [
      "0x8a35d142be1fcb950d280835791f576584b096237e240782215cd7b6f0818d1e",
      158667,
    ],
    [
      "0x13a3580b711d58fade486c2e710d6352932720514b2f265cc00ded1bb8c0853e",
      154600,
    ],
    [
      "0x769df4d93e8363d673a678b605caa6fb51b80c64bc6d160aae8d239b0b7d8f9c",
      151581,
    ],
    [
      "0xb74b397689e844cb5edc3c5408972e35126f03bd25182e6c868ee2827fcc3e3b",
      149457,
    ],
    [
      "0xe256dc1a435394ec16827eacfe2d9e06a4f06b830c85cb775722aa50f0577136",
      147684,
    ],
    [
      "0x1751c2c25851555b7b7b85de4dc6f563a3b71e8025aea34bbe6b283534970c5f",
      140590,
    ],
    [
      "0x005cc06771d756c2de8422fb082e0f0cf7f6471e95243e1c214602aeb6b5a3e4",
      56499,
    ],
    [
      "0xbe073d12ab572e01dbb0a3d870beb6bee0606c881a0c0b6b62467afeff24b2ed",
      36189,
    ],
    [
      "0xd8f9f807ed509a78d18900a1bbedcad9aafce629b564bf0f58d386b28fb832d5",
      10789,
    ],
    [
      "0x6c46b3cba075cf398fc6c253dc6d8913c60935ae2d200e122828bb0adfd82725",
      9618,
    ],
    [
      "0x3a29b785031e9d1c9f10b2e52f02d1570705d48c492560fad3ef951a148f8d9e",
      4844,
    ],
    [
      "0xe6a29003c738af83ccead6fb70c124d29a49ebaad94d1e751159a9769bfb67c2",
      4788,
    ],
    [
      "0x1b45326d5de5d09c03a664b083301cb39dc9b5c4934987451416637386e92452",
      4033,
    ],
    [
      "0x1233dbec9e47ed5ab393cb92a2a3b48cc27d79d0ceeb2c651c86b0690db44891",
      2609,
    ],
    [
      "0x063f8e3fb36999e2b50997cbe02e5cc1514da81d4772dbe22497ea09aa80bd3e",
      1773,
    ],
    [
      "0x29503ffd35ef07c9e3973ffaa6d4db01b49b3fe7b7e5d592d1ed6d16d3d0256e",
      1664,
    ],
    [
      "0x651f0d208e03529f818d331b640d475672edfa6f8b3b88ba90b174aa245db436",
      1520,
    ],
    ["0x2ee47ee88715e30ad82019201dfef0f959021e7d0e481b2a7199bca1a37d8cec", 703],
    ["0xc941a5317e5a20da26c5f471ad548e0aab1948a5980c31db681f4bae0d6fd1b2", 622],
    ["0x2f3e1a3526a28d96aa17fbc15b769cba32e76d27f7338b8e30154b36af564d61", 105],
    ["0x54712529b2b9a279a9d14692314c4a0c842c896fcb2b0747f51657896a99054d", 102],
    ["0x4590a434d6d784f1f6712a37080bf5b45fd264fe0932967f0780593459ac633d", 64],
    ["0xc6822d256b6affe1abbf43661871f034201a5ef81ebbb5015227d037db4cdaf8", 52],
    ["0x1d3af8c9058f5d5ace204764268d74f3d7dbadb0044747f52a053feff4fb92bd", 32],
    ["0xfcdfeb4b9f6cc6a8bee8e199bea2f88faea18790a2af7edf0ce06606873f7729", 32],
    ["0x8aed8a25eddafe150e8bec206f1cbd56f93ef91f159a3e999c19dff7d3372e80", 10],
    ["0x96725e909b44144350c7e0d820cd2db80e943f84c2324494aced085294d07e10", 6],
    ["0x4c41320408172f954b6ca4833fc2f2c96c5cb57fa9c80bed570b83823fd1a1fe", 2],
    ["0xd5376ae81700a8b1735c1aa380dc05257e80f187fe68ab2a5135bb4145277fb6", 1],
  ],
};

const inputHeader = {
  lib_AddressManager: process.env.Lib_AddressManager,
  height: 10340037,
  blockHash:
    "0xDDB010FECDA643EFB6E7F0FBCBB0A4AB7F23173F865B40EDF47139A3627E1200",
  dataHash:
    "0x677BF175DE9C1EDDD2F26AE4161631390A24486D44BBC71982C39965F58967C4",
  validatorHash:
    "0x1A695B879702E2CBA64500C4717D9A96C951ED2083124F1179B7E7223825EA6D",
};
let oraisanGate, OraisanGate;
let lib_AddressManager, Lib_AddressManager;
let cc, CC;
let AVL_Tree, avl_tree;
let cosmosValidators, CosmosValidators;
let CosmosBlockHeader, cosmosBlockHeader;
let processString, ProcessString;
let verifier, Verifier;
let verifier110, Verifier110;
let verifier111, Verifier111;
let tmHash, TmHash;
beforeEach(async () => {
  TmHash = await ethers.getContractFactory("TMHash");
  tmHash = await TmHash.deploy();
  await tmHash.deployed();

  Verifier111 = await ethers.getContractFactory(
    "VerifierValidatorSignature_111"
  );
  verifier111 = await upgrades.deployProxy(Verifier111, []);
  await verifier111.deployed();

  Verifier110 = await ethers.getContractFactory(
    "VerifierValidatorSignature_110"
  );
  verifier110 = await upgrades.deployProxy(Verifier110, []);
  await verifier110.deployed();

  Verifier = await ethers.getContractFactory("VerifierDataAndVals");
  verifier = await upgrades.deployProxy(Verifier, []);
  await verifier.deployed();

  ProcessString = await ethers.getContractFactory("ProcessString");
  processString = await upgrades.deployProxy(ProcessString, []);
  await processString.deployed();

  AVL_Tree = await ethers.getContractFactory("AVL_Tree");
  avl_tree = await upgrades.deployProxy(AVL_Tree, []);
  await avl_tree.deployed();

  Lib_AddressManager = await ethers.getContractFactory("Lib_AddressManager");
  lib_AddressManager = await upgrades.deployProxy(Lib_AddressManager, []);
  await lib_AddressManager.deployed();

  CosmosBlockHeader = await ethers.getContractFactory("CosmosBlockHeader");
  cosmosBlockHeader = await upgrades.deployProxy(CosmosBlockHeader, [
    lib_AddressManager.address,
    inputHeader.height,
    inputHeader.blockHash,
    inputHeader.dataHash,
    inputHeader.validatorHash,
  ]);
  await cosmosBlockHeader.deployed();

  CosmosValidators = await ethers.getContractFactory("CosmosValidators");
  cosmosValidators = await upgrades.deployProxy(CosmosValidators, [
    lib_AddressManager.address,
    input.currentHeight,
    input.numValidator,
    input.validatorSet,
  ]);
  await cosmosValidators.deployed();

  // await lib_AddressManager.setAddress();

  OraisanGate = await ethers.getContractFactory("OraisanGate");
  oraisanGate = await upgrades.deployProxy(OraisanGate, [
    lib_AddressManager.address,
  ]);
  await oraisanGate.deployed();

  await lib_AddressManager.setAddress("ORAISAN_GATE", oraisanGate.address);
  await lib_AddressManager.setAddress(
    "COSMOS_BLOCK_HEADER",
    cosmosBlockHeader.address
  );
  await lib_AddressManager.setAddress(
    "COSMOS_VALIDATORS",
    cosmosValidators.address
  );
  await lib_AddressManager.setAddress("AVL_TREE", avl_tree.address);
  await lib_AddressManager.setAddress("PROCESS_STRING", processString.address);
  await lib_AddressManager.setAddress(
    "VERIFIER_VALIDATOR_SIGNATURE_111",
    verifier111.address
  );
  await lib_AddressManager.setAddress(
    "VERIFIER_VALIDATOR_SIGNATURE_110",
    verifier110.address
  );
  await lib_AddressManager.setAddress(
    "VERIFIER_DATA_AND_VALS",
    verifier.address
  );
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
        // proof.R8,
        // proof.S,
      ];
      newProofs.push(newProof);
    });

    // console.log("avltree", avl_tree.address);
    // let add = await lib_AddressManager.getAddress("AVL_TREE");
    // console.log("add", add);

    // console.log("newAunts", newAunts);
    // console.log("newValidators", newValidators);

    await oraisanGate.verifyBlockHeader(newBlockData, newAunts, newValidators);

    // await owner.updateBlockHeader(newBlockData.height, newProof3);
    // await oraisanGate.verifyBlockHeader(newBlockData, newAunts, newValidators);
    // console.log("result", result);
    // let resultCC = await cc.ac(
    //   newBlockData,
    //   newAunts,
    //   newValidators,
    //   newProofs
    // );
    // // 10 elements of newProofs
    // let newProof10 = newProofs.slice(0, 32);
    // // let newValidator10 = newValidators.slice(0, 32);
    // let result1 = await cc.blockHeader(newBlockData);
    // let result2 = await cc.blockSibling(newAunts);
    // let result3 = await cc.blockValidator(newValidators);
    // let tx2 = await cc.ad(newBlockData, newAunts);
    // let receipt2 = await tx2.wait();
    // // gas spent
    // console.log("gasUsed", receipt2.gasUsed.toString());
    // //  gas price
    // console.log("gasPrice", receipt2.effectiveGasPrice.toString());
    // //
    // console.log(
    //   "gasUsed * gasPrice",
    //   receipt2.effectiveGasPrice * receipt2.gasUsed
    // );
    // for (let i = 1; i < newProofs.length; i++) {
    //   await cc.blockProof(newProofs[i]);
    // }
  });
});
