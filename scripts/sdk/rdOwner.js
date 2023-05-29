exports.owner = exports.rdOwnerLib_AddressManager =exports.rdOwnerOraisanBridge = exports.rdOwnerOraisanGate = exports.rdOwnerCosmosValidators = exports.rdOwnerCosmosBlockHeader = exports.rdOwnerAVL_Tree = exports.rdOwnerProcessString = void 0;
const { ethers } = require("hardhat");
require("dotenv").config();

const getOwner = () => {
    return new ethers.Wallet(process.env.PRIVATE_KEY, ethers.provider);
}
const owner = getOwner();
exports.owner = owner;


const rdOwnerLib_AddressManager = async () => {
    const RandLib_AddressManager = await ethers.getContractFactory("Lib_AddressManager");
    const rdLib_AddressManager =  RandLib_AddressManager.attach(process.env.Lib_AddressManager);
    const rdOwnerLib_AddressManager = rdLib_AddressManager.connect(owner);
    return rdOwnerLib_AddressManager;
}
exports.rdOwnerLib_AddressManager = rdOwnerLib_AddressManager;

const rdOwnerOraisanBridge = async () => {
    const RandOraisanBridge = await ethers.getContractFactory("OraisanBridge");
    const rdOraisanBridge =  RandOraisanBridge.attach(process.env.ORAISAN_BRIDGE);
    const rdOwnerOraisanBridge =  rdOraisanBridge.connect(owner);
    return rdOwnerOraisanBridge;
}
exports.rdOwnerOraisanBridge = rdOwnerOraisanBridge;

const rdOwnerOraisanGate = async () => {
    const RandOraisanGate = await ethers.getContractFactory("OraisanGate");
    const rdOraisanGate =  RandOraisanGate.attach(process.env.ORAISAN_GATE);
    const rdOwnerOraisanGate =  rdOraisanGate.connect(owner);
    return rdOwnerOraisanGate;
}
exports.rdOwnerOraisanGate = rdOwnerOraisanGate;

const rdOwnerCosmosValidators = async () => {
    const RandCosmosValidators = await ethers.getContractFactory("CosmosValidators");
    const rdCosmosValidators =  RandCosmosValidators.attach(process.env.COSMOS_VALIDATORS);
    const rdOwnerCosmosValidators =  rdCosmosValidators.connect(owner);
    return rdOwnerCosmosValidators;
}
exports.rdOwnerCosmosValidators = rdOwnerCosmosValidators;

const rdOwnerCosmosBlockHeader = async () => {
    const RandCosmosBlockHeader = await ethers.getContractFactory("CosmosBlockHeader");
    const rdCosmosBlockHeader =  RandCosmosBlockHeader.attach(process.env.COSMOS_BLOCK_HEADER);
    const rdOwnerCosmosBlockHeader =  rdCosmosBlockHeader.connect(owner);
    return rdOwnerCosmosBlockHeader;
}
exports.rdOwnerCosmosBlockHeader = rdOwnerCosmosBlockHeader;


