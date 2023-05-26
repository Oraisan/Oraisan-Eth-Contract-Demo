const { deployCosmosValidator } = require("./deploy");

const main = async () => {
    await deployCosmosValidator()
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

