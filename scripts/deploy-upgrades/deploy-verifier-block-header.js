const { deployVerifierBlockHeader } = require("./deploy");

const main = async () => {
    await deployVerifierBlockHeader();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });


