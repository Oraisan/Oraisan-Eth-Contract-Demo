exports.getCurrentBlockHeight = exports.getValidatorSetAtHeight = exports.getValidatorAtHeight =  void 0;
const { rdOwnerCosmosValidators } = require("./rdOwner");
require("dotenv").config();

const getCurrentBlockHeight = async () => {
    const rdOwner = await rdOwnerCosmosValidators();
    const currentHeight = await rdOwner.getCurrentBlockHeight();
    return currentHeight;
}
exports.getCurrentBlockHeight = getCurrentBlockHeight;

const getValidatorSetAtHeight = async (height) => {
    const rdOwner = await rdOwnerCosmosValidators();
    const validatorSet = await rdOwner.getValidatorSetAtHeight(height);
    return validatorSet;
}
exports.getValidatorSetAtHeight = getValidatorSetAtHeight;

const getValidatorAtHeight = async (height, index) => {
    const rdOwner = await rdOwnerCosmosValidators();
    const validator = await rdOwner.getValidatorAtHeight(height, index);
    return validator;
}
exports.getValidatorAtHeight = getValidatorAtHeight;