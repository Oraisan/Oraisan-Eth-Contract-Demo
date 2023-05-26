const { deployOraisanBridge } = require("./deploy");

const main = async () => {
    await deployOraisanBridge()
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

