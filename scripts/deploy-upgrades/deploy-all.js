const { deployCosmosBlockHeader, deployCosmosValidator, deployOraisanBridge, deployLib_AddressManager, deployOraisanGate, deployVerifierClaimTransaction, deployVerifierRootDeposit, deployVerifierValidatorSignature, deployVerifierValidatorsLeft, deployVerifierValidatorsRight } = require("./deploy");


const main = async () => {
    // await deployLib_AddressManager();
    await deployCosmosBlockHeader();
    // await deployCosmosValidator();
    // await deployOraisanBridge();
    // await deployOraisanGate();
    // await deployVerifierClaimTransaction();
    // await deployVerifierRootDeposit();
    // await deployVerifierValidatorSignature();
    // await deployVerifierValidatorsLeft();
    // await deployVerifierValidatorsRight();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

