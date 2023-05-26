exports.registerTokenPair = exports.updateRootDepositTree = void 0;
const { rdOwnerOraisanBridge } = require("./rdOwner");
const { getProofUpdateRootDeposit, getProofClaimTransaction } = require("../utils/getProof");
require("dotenv").config();

const registerTokenPair = async (_cosmosTokenAddress, _ethTokenAddress) => {
    const rdOwner = await rdOwnerOraisanBridge();
    await rdOwner.registerTokenPair(_cosmosTokenAddress, _ethTokenAddress);
    return (await rdOwner.cosmosToEthTokenAddress(_cosmosTokenAddress));
}
exports.registerTokenPair = registerTokenPair;

const updateRootDepositTree = async (pathInput, pathProof) => {
    const input = getProofUpdateRootDeposit(pathInput, pathProof);

    const rdOwner = await rdOwnerOraisanBridge();
    await rdOwner.updateRootDepositTree([
        input.optionName,
        input.pi_a,
        input.pi_b,
        input.pi_c,
        input.cosmosSender,
        input.cosmosBridge,
        input.depositRoot,
        input.dataHash
    ]);
    return (await rdOwner.getLastDepositRoot());
}
exports.updateRootDepositTree = updateRootDepositTree;

const claimTransaction = async (pathInput, pathProof) => {
    const input = getProofClaimTransaction(pathInput, pathProof);

    const rdOwner = await rdOwnerOraisanBridge();
    await rdOwner.claimTransaction([
        input.optionName,
        input.pi_a,
        input.pi_b,
        input.pi_c,
        input.eth_bridge_address,
        input.eth_receiver,
        input.amount,
        input.cosmos_token_address,
        input.depositRoot
    ]);
    return (await rdOwner.getLastDepositRoot());
}
exports.claimTransaction = claimTransaction;