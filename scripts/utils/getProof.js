
exports.getProofValidatorSignature = exports.getProofUpdateRootDeposit = void 0;
const { ethers } = require("hardhat");
const fs = require("fs");
const {readJsonFile, bigNumberToAddress} = require("../utils/helper")
require("dotenv").config();

// const abiCoder = ethers.utils.defaultAbiCoder;
function numToHex(num) {
    return ethers.utils.hexZeroPad(ethers.BigNumber.from(num).toHexString(), 32);
}

const getProofValidatorSignature =  (pathInput, pathProof) => {
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

const getProofUpdateRootDeposit = (pathInput, pathProof) => {
    const inputVerifierValidatorSignatureJson = readJsonFile(pathInput);
    const proofVerifierValidatorSignatureJson = readJsonFile(pathProof);
    const proofVerifierValidatorSignatureData = {
        a: proofVerifierValidatorSignatureJson.pi_a.slice(0, 2),
        b: proofVerifierValidatorSignatureJson.pi_b.slice(0, 2).map(e => e.reverse()),
        c: proofVerifierValidatorSignatureJson.pi_c.slice(0, 2)
    };

    const inputProof = {
        optionName: "VERIFIER_ROOT_DEPOSIT",
        pi_a: proofVerifierValidatorSignatureData.a,
        pi_b: proofVerifierValidatorSignatureData.b,
        pi_c: proofVerifierValidatorSignatureData.c,
        cosmosSender: inputVerifierValidatorSignatureJson[0],
        cosmosBridge: inputVerifierValidatorSignatureJson[1],
        depositRoot: inputVerifierValidatorSignatureJson[2],
        dataHash: inputVerifierValidatorSignatureJson[3]
    };
    return inputProof;
}
exports.getProofUpdateRootDeposit = getProofUpdateRootDeposit;

const getProofClaimTransaction = (pathInput, pathProof) => {
    const inputVerifierValidatorSignatureJson = JSON.parse(fs.readFileSync(pathInput).toString());
    const proofVerifierValidatorSignatureJson = JSON.parse(fs.readFileSync(pathProof).toString());
    const proofVerifierValidatorSignatureData = {
        a: proofVerifierValidatorSignatureJson.pi_a.slice(0, 2),
        b: proofVerifierValidatorSignatureJson.pi_b.slice(0, 2).map(e => e.reverse()),
        c: proofVerifierValidatorSignatureJson.pi_c.slice(0, 2)
    };

    const inputProof = {
        optionName: "VERIFIER_CLAIM_TRANSACTION",
        pi_a: proofVerifierValidatorSignatureData.a,
        pi_b: proofVerifierValidatorSignatureData.b,
        pi_c: proofVerifierValidatorSignatureData.c,
        eth_bridge_address: bigNumberToAddress(inputVerifierValidatorSignatureJson[0]),
        eth_receiver: bigNumberToAddress(inputVerifierValidatorSignatureJson[1]),
        amount: inputVerifierValidatorSignatureJson[2],
        cosmos_token_address: inputVerifierValidatorSignatureJson[3],
        depositRoot: inputVerifierValidatorSignatureJson[4]
    };
    return inputProof;
}
exports.getProofClaimTransaction = getProofClaimTransaction;

