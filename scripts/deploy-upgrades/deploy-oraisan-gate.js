const { deployOraisanGate } = require("./deploy");

const main = async () => {
    await deployOraisanGate();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

