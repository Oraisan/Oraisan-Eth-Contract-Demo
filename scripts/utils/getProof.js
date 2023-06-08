
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
    const inputUpdateDepositRootJson = readJsonFile(pathInput);
    const proofUpdateDepositRootJson = readJsonFile(pathProof);
    const proofUpdateDepositRootData = {
        a: proofUpdateDepositRootJson.pi_a.slice(0, 2),
        b: proofUpdateDepositRootJson.pi_b.slice(0, 2).map(e => e.reverse()),
        c: proofUpdateDepositRootJson.pi_c.slice(0, 2)
    };

    const inputProof = {
        optionName: "VERIFIER_ROOT_DEPOSIT",
        pi_a: proofUpdateDepositRootData.a,
        pi_b: proofUpdateDepositRootData.b,
        pi_c: proofUpdateDepositRootData.c,
        cosmosSender: inputUpdateDepositRootJson[0],
        cosmosBridge: inputUpdateDepositRootJson[1],
        depositRoot: inputUpdateDepositRootJson[2],
        dataHash: inputUpdateDepositRootJson[3]
    };
    return inputProof;
}
exports.getProofUpdateRootDeposit = getProofUpdateRootDeposit;

const getProofClaimTransaction = (pathInput, pathProof) => {
    const inputVerifierClaimTransactionJson = JSON.parse(fs.readFileSync(pathInput).toString());
    const proofVerifierClaimTransactionJson = JSON.parse(fs.readFileSync(pathProof).toString());
    const proofVerifierClaimTransactionData = {
        a: proofVerifierClaimTransactionJson.pi_a.slice(0, 2),
        b: proofVerifierClaimTransactionJson.pi_b.slice(0, 2).map(e => e.reverse()),
        c: proofVerifierClaimTransactionJson.pi_c.slice(0, 2)
    };

    const inputProof = {
        optionName: "VERIFIER_CLAIM_TRANSACTION",
        pi_a: proofVerifierClaimTransactionData.a,
        pi_b: proofVerifierClaimTransactionData.b,
        pi_c: proofVerifierClaimTransactionData.c,
        eth_bridge_address: bigNumberToAddress(inputVerifierClaimTransactionJson[0]),
        eth_receiver: bigNumberToAddress(inputVerifierClaimTransactionJson[1]),
        amount: inputVerifierClaimTransactionJson[2],
        eth_token_address: bigNumberToAddress(inputVerifierClaimTransactionJson[3]),
        key: inputVerifierClaimTransactionJson[4],
        depositRoot: inputVerifierClaimTransactionJson[5]
    };
    return inputProof;
}
exports.getProofClaimTransaction = getProofClaimTransaction;

