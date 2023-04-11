const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
    const AVL_Tree = await ethers.getContractFactory("AVL_Tree");
    console.log(
        await upgrades.upgradeProxy(
            process.env.AVL_TREE,
            AVL_Tree
        )
    );

    console.log("AVL_Tree upgraded");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

