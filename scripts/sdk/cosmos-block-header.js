exports.getCurrentBlockHeight = exports.getBlockHash = exports.getCurrentDataHash = exports.getDataHash = void 0;
const { rdOwnerCosmosBlockHeader } = require("./rdOwner");
require("dotenv").config();

const getCurrentBlockHeight = async () => {
    const rdOwner = await rdOwnerCosmosBlockHeader();
    const currentHeight = await rdOwner.getCurrentBlockHeight();
    return currentHeight;
}
exports.getCurrentBlockHeight = getCurrentBlockHeight;

const getCurrentBlockHash = async () => {
    const rdOwner = await rdOwnerCosmosBlockHeader();
    const blockHash = await rdOwner.getCurrentBlockHash();
    return blockHash;
}
exports.getCurrentBlockHash = getCurrentBlockHash;

const getBlockHash = async (height) => {
    const rdOwner = await rdOwnerCosmosBlockHeader();
    const blockHashAtHeight = await rdOwner.getBlockHash(height);
    return blockHashAtHeight;
}
exports.getBlockHash = getBlockHash;

const getCurrentDataHash = async () => {
    const rdOwner = await rdOwnerCosmosBlockHeader();
    const dataHash = await rdOwner.getCurrentDataHash();
    return dataHash;
}
exports.getCurrentDataHash = getCurrentDataHash;

const getDataHash = async (height) => {
    const rdOwner = await rdOwnerCosmosBlockHeader();
    const dataHashAtHeight = await rdOwner.getDataHash(height);
    return dataHashAtHeight;
}
exports.getDataHash = getDataHash;