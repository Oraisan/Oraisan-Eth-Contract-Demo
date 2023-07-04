
exports.getProofValidatorSignature = exports.getProofUpdateRootDeposit = void 0;
const { ethers } = require("hardhat");
const fs = require("fs");
const {readJsonFile, convertHexStringToAddress, bigNumberToHexString} = require("../utils/helper")
require("dotenv").config();

// const abiCoder = ethers.utils.defaultAbiCoder;
function numToHex(num) {
    return ethers.utils.hexZeroPad(ethers.BigNumber.from(num).toHexString(), 32);
}

const getProofBlockHeader =  (pathInput, pathProof) => {
    const inputVerifierBlockHeaderJson = JSON.parse(fs.readFileSync(pathInput).toString());
    const proofVerifierBlockHeaderJson = JSON.parse(fs.readFileSync(pathProof).toString());
    const proofVerifierBlockHeaderData = {
        a: proofVerifierBlockHeaderJson.pi_a.slice(0, 2),
        b: proofVerifierBlockHeaderJson.pi_b.slice(0, 2).map(e => e.reverse()),
        c: proofVerifierBlockHeaderJson.pi_c.slice(0, 2)
    };
    console.log(inputVerifierBlockHeaderJson)
    const inputProof = {
        optionName: "VERIFIER_BLOCK_HEADER",
        pi_a: proofVerifierBlockHeaderData.a,
        pi_b: proofVerifierBlockHeaderData.b,
        pi_c: proofVerifierBlockHeaderData.c,
        validatorAddress: convertHexStringToAddress(bigNumberToHexString((inputVerifierBlockHeaderJson[0]))),
        validatorHash: convertHexStringToAddress(bigNumberToHexString((inputVerifierBlockHeaderJson[1]))),
        dataHash: convertHexStringToAddress(bigNumberToHexString((inputVerifierBlockHeaderJson[2]))),
        blockHash: convertHexStringToAddress(bigNumberToHexString((inputVerifierBlockHeaderJson[3]))),
        height: inputVerifierBlockHeaderJson[4],
    };
    console.log(inputProof)
    return inputProof;
}
exports.getProofBlockHeader = getProofBlockHeader;

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
        cosmosSender: convertHexStringToAddress(bigNumberToHexString(inputUpdateDepositRootJson[0])),
        cosmosBridge: convertHexStringToAddress(bigNumberToHexString(inputUpdateDepositRootJson[1])),
        depositRoot: inputUpdateDepositRootJson[2],
        dataHash: convertHexStringToAddress(bigNumberToHexString(inputUpdateDepositRootJson[3]))
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
        eth_bridge_address: convertHexStringToAddress(bigNumberToHexString(inputVerifierClaimTransactionJson[0])),
        eth_receiver: convertHexStringToAddress(bigNumberToHexString(inputVerifierClaimTransactionJson[1])),
        amount: inputVerifierClaimTransactionJson[2],
        eth_token_address: convertHexStringToAddress(bigNumberToHexString(inputVerifierClaimTransactionJson[3])),
        key: inputVerifierClaimTransactionJson[4],
        depositRoot: inputVerifierClaimTransactionJson[5]
    };
    return inputProof;
}
exports.getProofClaimTransaction = getProofClaimTransaction;

