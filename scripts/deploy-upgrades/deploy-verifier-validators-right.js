const { deployVerifierValidatorsRight } = require("./deploy");

const main = async () => {
    await deployVerifierValidatorsRight();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });


