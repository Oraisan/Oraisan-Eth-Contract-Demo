
exports.getProofAddRH = exports.getProofPMul1 = exports.getProofEncodeMessage = void 0;
const { ethers } = require("hardhat");
const fs = require("fs");
const { genSignature } = require("./signature");
require("dotenv").config();

// const abiCoder = ethers.utils.defaultAbiCoder;
function numToHex(num) {
    return ethers.utils.hexZeroPad(ethers.BigNumber.from(num).toHexString(), 32);
}

const getProofAddRH = async (pathInput, pathProof) => {
    const inputAddRHJson = JSON.parse(fs.readFileSync(pathInput).toString());
    const proofAddRHJson = JSON.parse(fs.readFileSync(pathProof).toString());
    const proofAddRHData = {
        a: proofAddRHJson.pi_a.slice(0, 2),
        b: proofAddRHJson.pi_b.slice(0, 2).map(e => e.reverse()),
        c: proofAddRHJson.pi_c.slice(0, 2)
    };

    const inputProof = {
        optionName: "VERIFIER_ADDRH",
        pi_a: proofAddRHData.a,
        pi_b: proofAddRHData.b,
        pi_c: proofAddRHData.c,
        input: inputAddRHJson
    };
    return inputProof;
}
exports.getProofAddRH = getProofAddRH;

const getProofPMul1 = async (pathInput, pathProof) => {
    const inputPMul1Json = JSON.parse(fs.readFileSync(pathInput).toString());
    const proofPMul1Json = JSON.parse(fs.readFileSync(pathProof).toString());
    const proofPMul1Data = {
        a: proofPMul1Json.pi_a.slice(0, 2),
        b: proofPMul1Json.pi_b.slice(0, 2).map(e => e.reverse()),
        c: proofPMul1Json.pi_c.slice(0, 2),
    };

    const inputProof = {
        optionName: "VERIFIER_PMUL1",
        pi_a: proofPMul1Data.a,
        pi_b: proofPMul1Data.b,
        pi_c: proofPMul1Data.c,
        input: inputPMul1Json
    };
    return inputProof;
}
exports.getProofPMul1 = getProofPMul1;

const getProofEncodeMessage = async (pathInput, pathProof) => {
    const inputEncodeMessageJson = JSON.parse(fs.readFileSync(pathInput).toString());
    const proofEncodeMessageJson = JSON.parse(fs.readFileSync(pathProof).toString());

    const inputProof = {
        optionName: `VERIFIER_ENCODE_MESSAGE`,
        pi_a: proofEncodeMessageJson.pi_a.slice(0, 2),
        pi_b: proofEncodeMessageJson.pi_b.slice(0, 2).map(e => e.reverse()),
        pi_c: proofEncodeMessageJson.pi_c.slice(0, 2),
        input: inputEncodeMessageJson
    };
    return inputProof;
}
exports.getProofEncodeMessage = getProofEncodeMessage;
