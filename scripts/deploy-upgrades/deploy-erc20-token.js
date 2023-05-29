const { deployERC20Token } = require("./deploy");

const main = async () => {
    await deployERC20Token("Hijikata", "Hijin", process.env.ORAISAN_BRIDGE)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

