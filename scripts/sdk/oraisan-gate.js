exports.updateBlockHeader = void 0;

const { rdOwnerOraisanGate, rdOwnerCosmosBlockHeader } = require("./rdOwner");
const { getProofBlockHeader } = require("../utils/getProof");
require("dotenv").config();

const updateBlockHeader = async (pathInput, pathProof) => {
    const input = getProofBlockHeader(pathInput, pathProof);
    // console.log(input)
    const rdOwner = await rdOwnerOraisanGate();

    const res = await rdOwner.updateblockHeaderTestnet([
        input.optionName,
        input.pi_a,
        input.pi_b,
        input.pi_c,
        input.height,
        input.validatorAddress,
        input.validatorHash,
        input.dataHash,
        input.blockHash,
    ],
        { gasLimit: 498e5 }
        );
    await res.wait();
    return (await (await rdOwnerCosmosBlockHeader()).getCurrentBlockHash());
}
exports.updateBlockHeader = updateBlockHeader;
