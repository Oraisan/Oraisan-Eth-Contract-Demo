const { ethers, upgrades } = require("hardhat");
const { readJsonFile, getAddresFromHexString, writeToEnvFile } = require("../utils/helper");
require("dotenv").config();

const deployLib_AddressManager = async () => {
    let Lib_AddressManager = await ethers.getContractFactory("Lib_AddressManager");
    let lib_AddressManager = await upgrades.deployProxy(Lib_AddressManager, []);

    await lib_AddressManager.deployed();
    console.log("Lib_AddressManager deployed at: ", lib_AddressManager.address);
    writeToEnvFile("Lib_AddressManager", lib_AddressManager.address)
}
exports.deployLib_AddressManager = deployLib_AddressManager;

const getCosmosBlockHeaderConstructor = () => {
    const data = readJsonFile("./resources/cosmosHeader/cosmosHeader.json")

    const inputBlockHeader = {
        lib_AddressManager: process.env.Lib_AddressManager,
        height: parseInt(data.header.height),
        blockHash: getAddresFromHexString(data.commit.block_id.hash),
        dataHash: getAddresFromHexString(data.header.data_hash),
        validatorHash: getAddresFromHexString(data.header.validators_hash)
    }
    return inputBlockHeader
}


const deployCosmosBlockHeader = async () => {
    const input = getCosmosBlockHeaderConstructor();
    // console.log(input)
    const CosmosBlockHeader = await ethers.getContractFactory("CosmosBlockHeader");
    const cosmosBlockHeader = await upgrades.deployProxy(CosmosBlockHeader,
        [
            input.lib_AddressManager,
            input.height,
            input.blockHash,
            input.dataHash,
            input.validatorHash
        ]);
    await cosmosBlockHeader.deployed();
    console.log("CosmosBlockHeader dedployed at: ", cosmosBlockHeader.address);
    writeToEnvFile("COSMOS_BLOCK_HEADER", cosmosBlockHeader.address)
}
exports.deployCosmosBlockHeader = deployCosmosBlockHeader;

const getCosmosValidatorsConstructor = () => {
    const data = readJsonFile("./resources/cosmosHeader/cosmosHeader.json")

    const validatorAddresses = [];
    for (i = 0; i < data.commit.signatures.length; i++) {
        validatorAddresses.push(data.commit.signatures[i].validator_address)
    }

    const inputValidators = {
        lib_AddressManager: process.env.Lib_AddressManager,
        height: parseInt(data.header.height),
        validatorAddresses: validatorAddresses
    }
    return inputValidators
}

const deployCosmosValidator = async () => {
    const input = getCosmosValidatorsConstructor();
    const CosmosValidators = await ethers.getContractFactory("CosmosValidators");
    const cosmosValidators = await upgrades.deployProxy(CosmosValidators,
        [
            input.lib_AddressManager,
            input.currentHeight,
            input.validatorAddresses
        ]);
    await cosmosValidators.deployed();
    console.log("CosmosValidators dedployed at: ", cosmosValidators.address);
    writeToEnvFile("COSMOS_VALIDATORS", cosmosValidators.address)
}
exports.deployCosmosValidator = deployCosmosValidator;

const deployOraisanBridge = async () => {
    const OraisanBridge = await ethers.getContractFactory("OraisanBridge");
    const oraisanBridge = await upgrades.deployProxy(OraisanBridge,
        [
            process.env.Lib_AddressManager,
            32,
            process.env.COSMOS_BRIDGE
        ]);
    await oraisanBridge.deployed();
    console.log("OraisanBridge dedployed at: ", oraisanBridge.address);
    writeToEnvFile("ORAISAN_BRIDGE", oraisanBridge.address)
}
exports.deployOraisanBridge = deployOraisanBridge;

const deployOraisanGate = async () => {
    const OraisanGate = await ethers.getContractFactory("OraisanGate");
    const oraisanGate = await upgrades.deployProxy(OraisanGate,
        [
            process.env.Lib_AddressManager
        ]);
    await oraisanGate.deployed();
    console.log("OraisanGate dedployed at: ", oraisanGate.address);
    writeToEnvFile("ORAISAN_GATE", oraisanGate.address)
}
exports.deployOraisanGate = deployOraisanGate;

const deployVerifierClaimTransaction = async () => {
    const Verifier = await ethers.getContractFactory("VerifierClaimTransaction");
    const verifier = await upgrades.deployProxy(Verifier, []);
    await verifier.deployed();
    console.log("VerifierClaimTransaction dedployed at: ", verifier.address);
    writeToEnvFile("VERIFIER_CLAIM_TRANSACTION", verifier.address)
}
exports.deployVerifierClaimTransaction = deployVerifierClaimTransaction;

const deployVerifierRootDeposit = async () => {
    const Verifier = await ethers.getContractFactory("VerifierRootDeposit");
    const verifier = await upgrades.deployProxy(Verifier, []);
    await verifier.deployed();
    console.log("VerifierRootDeposit dedployed at: ", verifier.address);
    writeToEnvFile("VERIFIER_ROOT_DEPOSIT", verifier.address)
}
exports.deployVerifierRootDeposit = deployVerifierRootDeposit;

const deployVerifierValidatorSignature = async () => {
    const Verifier = await ethers.getContractFactory("VerifierValidatorSignature");
    const verifier = await upgrades.deployProxy(Verifier, []);
    await verifier.deployed();
    console.log("VerifierValidatorSignature dedployed at: ", verifier.address);
    writeToEnvFile("VERIFIER_VALIDATOR_SIGNATURE", verifier.address)
}
exports.deployVerifierValidatorSignature = deployVerifierValidatorSignature;

const deployVerifierValidatorsLeft = async () => {
    const Verifier = await ethers.getContractFactory("VerifierValidatorsLeft");
    const verifier = await upgrades.deployProxy(Verifier, []);
    await verifier.deployed();
    console.log("VerifierValidatorsLeft dedployed at: ", verifier.address);
    writeToEnvFile("VERIFIER_VALIDATORS_LEFT", verifier.address)
}
exports.deployVerifierValidatorsLeft = deployVerifierValidatorsLeft;

const deployVerifierValidatorsRight = async () => {
    const Verifier = await ethers.getContractFactory("VerifierValidatorsRight");
    const verifier = await upgrades.deployProxy(Verifier, []);
    await verifier.deployed();
    console.log("VerifierValidatorsRight dedployed at: ", verifier.address);
    writeToEnvFile("VERIFIER_VALIDATORS_RIGHT", verifier.address)
}
exports.deployVerifierValidatorsRight = deployVerifierValidatorsRight;
