const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
    const ProcessString = await ethers.getContractFactory("ProcessString");
    console.log(
        await upgrades.upgradeProxy(
            process.env.PROCESS_STRING,
            ProcessString
        )
    );

    console.log("ProcessString upgraded");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

