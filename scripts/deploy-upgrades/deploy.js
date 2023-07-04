const { ethers, upgrades } = require("hardhat");
const { readJsonFile, getAddresFromHexString, writeToEnvFile, bigNumberToHexString, convertHexStringToAddress } = require("../utils/helper");
const { setLib_AddressManager } = require("../sdk/libAddressManager");
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
        validatorAddresses.push(convertHexStringToAddress(("0x" + data.commit.signatures[i].validator_address).toString()))
    }

    const inputValidators = {
        lib_AddressManager: process.env.Lib_AddressManager,
        height: data.header.height,
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
            input.height,
            [...input.validatorAddresses]
        ]);
    await cosmosValidators.deployed();
    console.log("CosmosValidators dedployed at: ", cosmosValidators.address);
    await setLib_AddressManager("COSMOS_VALIDATORS", cosmosValidators.address)
    writeToEnvFile("COSMOS_VALIDATORS", cosmosValidators.address)
}
exports.deployCosmosValidator = deployCosmosValidator;

const deployOraisanBridge = async () => {
    const OraisanBridge = await ethers.getContractFactory("OraisanBridge");
    const oraisanBridge = await upgrades.deployProxy(OraisanBridge,
        [
            process.env.Lib_AddressManager,
            32
        ]);
    await oraisanBridge.deployed();
    console.log("OraisanBridge dedployed at: ", oraisanBridge.address);
    await setLib_AddressManager("ORAISAN_BRIDGE", oraisanBridge.address)
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
    await setLib_AddressManager("ORAISAN_GATE", oraisanGate.address)
    writeToEnvFile("ORAISAN_GATE", oraisanGate.address)
}
exports.deployOraisanGate = deployOraisanGate;

const deployVerifierClaimTransaction = async () => {
    const Verifier = await ethers.getContractFactory("VerifierClaimTransaction");
    const verifier = await upgrades.deployProxy(Verifier, []);
    await verifier.deployed();
    console.log("VerifierClaimTransaction dedployed at: ", verifier.address);
    await setLib_AddressManager("VERIFIER_CLAIM_TRANSACTION", verifier.address)
    writeToEnvFile("VERIFIER_CLAIM_TRANSACTION", verifier.address)
}
exports.deployVerifierClaimTransaction = deployVerifierClaimTransaction;

const deployVerifierRootDeposit = async () => {
    const Verifier = await ethers.getContractFactory("VerifierRootDeposit");
    const verifier = await upgrades.deployProxy(Verifier, []);
    await verifier.deployed();
    console.log("VerifierRootDeposit dedployed at: ", verifier.address);
    await setLib_AddressManager("VERIFIER_ROOT_DEPOSIT", verifier.address)
    writeToEnvFile("VERIFIER_ROOT_DEPOSIT", verifier.address)
}
exports.deployVerifierRootDeposit = deployVerifierRootDeposit;

const deployVerifierBlockHeader = async () => {
    const Verifier = await ethers.getContractFactory("VerifierBlockHeader");
    const verifier = await upgrades.deployProxy(Verifier, []);
    await verifier.deployed();
    console.log("VerifierBlockHeader dedployed at: ", verifier.address);
    await setLib_AddressManager("VERIFIER_BLOCK_HEADER", verifier.address)
    writeToEnvFile("VERIFIER_BLOCK_HEADER", verifier.address)
}
exports.deployVerifierBlockHeader = deployVerifierBlockHeader;

const deployVerifierValidatorSignature = async () => {
    const Verifier = await ethers.getContractFactory("VerifierValidatorSignature");
    const verifier = await upgrades.deployProxy(Verifier, []);
    await verifier.deployed();
    console.log("VerifierValidatorSignature dedployed at: ", verifier.address);
    await setLib_AddressManager("VERIFIER_VALIDATOR_SIGNATURE", verifier.address)
    writeToEnvFile("VERIFIER_VALIDATOR_SIGNATURE", verifier.address)
}
exports.deployVerifierValidatorSignature = deployVerifierValidatorSignature;

const deployVerifierValidatorsLeft = async () => {
    const Verifier = await ethers.getContractFactory("VerifierValidatorsLeft");
    const verifier = await upgrades.deployProxy(Verifier, []);
    await verifier.deployed();
    console.log("VerifierValidatorsLeft dedployed at: ", verifier.address);
    await setLib_AddressManager("VERIFIER_VALIDATORS_LEFT", verifier.address)
    writeToEnvFile("VERIFIER_VALIDATORS_LEFT", verifier.address)
}
exports.deployVerifierValidatorsLeft = deployVerifierValidatorsLeft;

const deployVerifierValidatorsRight = async () => {
    const Verifier = await ethers.getContractFactory("VerifierValidatorsRight");
    const verifier = await upgrades.deployProxy(Verifier, []);
    await verifier.deployed();
    console.log("VerifierValidatorsRight dedployed at: ", verifier.address);
    await setLib_AddressManager("VERIFIER_VALIDATORS_RIGHT", verifier.address)
    writeToEnvFile("VERIFIER_VALIDATORS_RIGHT", verifier.address)
}
exports.deployVerifierValidatorsRight = deployVerifierValidatorsRight;

const deployERC20Token = async (name, value, ethBridge) => {
    const ERC20Token = await ethers.getContractFactory("ERC20Token");
    const eRC20Token = await upgrades.deployProxy(ERC20Token, [
        name, 
        value,
        ethBridge
    ]);
    await eRC20Token.deployed();
    console.log("ERC20Token dedployed at: ", eRC20Token.address);
    await setLib_AddressManager("ETH_TOKEN", eRC20Token.address)
    writeToEnvFile("ETH_TOKEN", eRC20Token.address)
}
exports.deployERC20Token = deployERC20Token;