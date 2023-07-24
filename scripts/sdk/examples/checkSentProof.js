const { getAddresFromAsciiString, readJsonFile, bigNumberToHexString, convertHexStringToAddress } = require("../../utils/helper");
const { isSentProof } = require("../oraisan-bridge")

require("dotenv").config();

const main = async () => {
    const inputVerifierClaimTransactionJson = readJsonFile("./resources/verifyClaimTransaction/public.json");
    const publicInput = {
        eth_bridge_address: convertHexStringToAddress(bigNumberToHexString(inputVerifierClaimTransactionJson[0])),
        eth_receiver: convertHexStringToAddress(bigNumberToHexString(inputVerifierClaimTransactionJson[1])),
        amount: inputVerifierClaimTransactionJson[2],
        eth_token_address: convertHexStringToAddress(bigNumberToHexString(inputVerifierClaimTransactionJson[3])),
        key: inputVerifierClaimTransactionJson[4],
        depositRoot: inputVerifierClaimTransactionJson[5]
    };
    const isSent = await isSentProof(
        publicInput.eth_bridge_address,
        publicInput.eth_receiver,
        publicInput.amount,
        publicInput.eth_token_address,
        publicInput.key
    );
    console.log("isSent: ", isSent);
};

main()
    .then(() => { })
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
