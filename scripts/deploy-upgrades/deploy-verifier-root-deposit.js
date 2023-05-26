const { deployVerifierRootDeposit } = require("./deploy");

const main = async () => {
    await deployVerifierRootDeposit();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });


