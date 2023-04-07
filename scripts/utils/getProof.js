
exports.getProofValidatorSignature = void 0;
const { ethers } = require("hardhat");
const fs = require("fs");
const { genSignature } = require("./signature");
require("dotenv").config();

// const abiCoder = ethers.utils.defaultAbiCoder;
function numToHex(num) {
    return ethers.utils.hexZeroPad(ethers.BigNumber.from(num).toHexString(), 32);
}

const getProofValidatorSignature = async (pathInput, pathProof) => {
    const inputVerifierValidatorSignatureJson = JSON.parse(fs.readFileSync(pathInput).toString());
    const proofVerifierValidatorSignatureJson = JSON.parse(fs.readFileSync(pathProof).toString());
    const proofVerifierValidatorSignatureData = {
        a: proofVerifierValidatorSignatureJson.pi_a.slice(0, 2),
        b: proofVerifierValidatorSignatureJson.pi_b.slice(0, 2).map(e => e.reverse()),
        c: proofVerifierValidatorSignatureJson.pi_c.slice(0, 2)
    };

    const inputProof = {
        optionName: "VERIFIER_VALIDATOR_SIGNATURE",
        pi_a: proofVerifierValidatorSignatureData.a,
        pi_b: proofVerifierValidatorSignatureData.b,
        pi_c: proofVerifierValidatorSignatureData.c,
        input: inputVerifierValidatorSignatureJson
    };
    return inputProof;
}
exports.getProofValidatorSignature = getProofValidatorSignature;

