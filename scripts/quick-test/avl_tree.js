const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
    const AVL_Tree = await ethers.getContractFactory("contracts/eth-bridge/utils/AVL_Tree.sol:AVL_Tree");
    const contract = await upgrades.deployProxy(AVL_Tree, []);
    await contract.deployed();
    console.log("AVL_Tree dedployed at: ", contract.address);

    const proofDataHash = {
        Total: 14,
        Index: 6,
        LeafHash:
            "0x47d8cf257fc42801a8e300577230cc3b45207110eeb7724f57e3f1ba5c828502",
        Aunts: [
            "0x8A301484E30737BBB11F409421839213A6CD5A2BBEB27C51464CB893A999DDC7",
            "0x3110DB763FAC7DB275B7A82CF0F69EA4BA83281C690FE3851F29C5DB5F1AE086",
            "0x1B3B374D2E98278E34B808FB9B61ED4BEA528A41DE20DC2D2154DB4B06872AC1",
            "0x021BAC303EB2E23EC3D446693449C5CA92E430EFEC8EE569C700B03A3B746A7D",
        ],
    };
    const root = await contract.calulateRootBySiblings(proofDataHash.Index, proofDataHash.Total, proofDataHash.LeafHash, proofDataHash.Aunts);
    console.log(root == "0xd76e82f31e67856b51f9eb02f1ffffaffa53fb14a0de70c4325e282aecf65648" ? "test ok" : "test not ok");
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });


