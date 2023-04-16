const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
  const AVL_Tree = await ethers.getContractFactory("CC");
  const avl_tree = await AVL_Tree.deploy();
  await avl_tree.deployed();
  console.log("AVL_Tree dedployed at: ", avl_tree.address);
};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
