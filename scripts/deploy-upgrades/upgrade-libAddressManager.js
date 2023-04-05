const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
    const Lib_AddressManager = await ethers.getContractFactory("Lib_AddressManager");
    console.log(
        await upgrades.upgradeProxy(
            process.env.Lib_AddressManager,
            Lib_AddressManager
        )
    );

    console.log("Lib_AddressManager upgraded");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });


