exports.owner = exports.rdOwnerLib_AddressManager = exports.rdOwnerOraisanGate = exports.rdOwnerCosmosValidators = exports.rdOwnerCosmosBlockHeader = exports.rdOwnerAVL_Tree = exports.rdOwnerProcessString = void 0;
const { ethers } = require("hardhat");
require("dotenv").config();

const getOwner = () => {
    return new ethers.Wallet(process.env.PRIVATE_KEY, ethers.provider);
}
const owner = getOwner();
exports.owner = owner;


const rdOwnerLib_AddressManager = async () => {
    const RandLib_AddressManager = await ethers.getContractFactory("Lib_AddressManager");
    const rdLib_AddressManager = await RandLib_AddressManager.attach(process.env.Lib_AddressManager);
    const rdOwnerLib_AddressManager = await rdLib_AddressManager.connect(owner);
    return rdOwnerLib_AddressManager;
}
exports.rdOwnerLib_AddressManager = rdOwnerLib_AddressManager;

const rdOwnerOraisanGate = async () => {
    const RandOraisanGate = await ethers.getContractFactory("OraisanGate");
    const rdOraisanGate = await RandOraisanGate.attach(process.env.ORAISAN_GATE);
    const rdOwnerOraisanGate = await rdOraisanGate.connect(owner);
    return rdOwnerOraisanGate;
}
exports.rdOwnerOraisanGate = rdOwnerOraisanGate;

const rdOwnerCosmosValidators = async () => {
    const RandCosmosValidators = await ethers.getContractFactory("CosmosValidators");
    const rdCosmosValidators = await RandCosmosValidators.attach(process.env.COSMOS_VALIDATORS);
    const rdOwnerCosmosValidators = await rdCosmosValidators.connect(owner);
    return rdOwnerCosmosValidators;
}
exports.rdOwnerCosmosValidators = rdOwnerCosmosValidators;

const rdOwnerCosmosBlockHeader = async () => {
    const RandCosmosBlockHeader = await ethers.getContractFactory("CosmosBlockHeader");
    const rdCosmosBlockHeader = await RandCosmosBlockHeader.attach(process.env.COSMOS_BLOCK_HEADER);
    const rdOwnerCosmosBlockHeader = await rdCosmosBlockHeader.connect(owner);
    return rdOwnerCosmosBlockHeader;
}
exports.rdOwnerCosmosBlockHeader = rdOwnerCosmosBlockHeader;

const rdOwnerAVL_Tree = async () => {
    const RandAVL_Tree = await ethers.getContractFactory("AVL_Tree");
    const rdAVL_Tree = await RandAVL_Tree.attach(process.env.AVL_TREE);
    const rdOwnerAVL_Tree = await rdAVL_Tree.connect(owner);
    return rdOwnerAVL_Tree;
}
exports.rdOwnerAVL_Tree = rdOwnerAVL_Tree;

const rdOwnerProcessString = async () => {
    const RandProcessString = await ethers.getContractFactory("ProcessString");
    const rdProcessString = await RandProcessString.attach(process.env.PROCESS_STRING);
    const rdOwnerProcessString = await rdProcessString.connect(owner);
    return rdOwnerProcessString;
}
exports.rdOwnerProcessString = rdOwnerProcessString;