const { deployVerifierValidatorsLeft } = require("./deploy");

const main = async () => {
    await deployVerifierValidatorsLeft();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });


