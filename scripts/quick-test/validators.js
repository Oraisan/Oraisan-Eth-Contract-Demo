const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const main = async () => {
    const VerifierAddRH = await ethers.getContractFactory("contracts/verifiers/validators/VerifierAddRH.sol:Verifier");
    const verifierAddRH = await upgrades.deployProxy(VerifierAddRH, []);
    await verifierAddRH.deployed();
    console.log("VerifierAddRH dedployed at: ", verifierAddRH.address);

    const VerifierPMul1 = await ethers.getContractFactory("contracts/verifiers/validators/VerifierPMul1.sol:Verifier");
    const verifierPMul1 = await upgrades.deployProxy(VerifierPMul1, []);
    await verifierPMul1.deployed();
    console.log("VerifierPMul1 dedployed at: ", verifierPMul1.address);

    const RandLib_AddressManager = await ethers.getContractFactory("Lib_AddressManager");
    const addressManager = await upgrades.deployProxy(RandLib_AddressManager, []);
    await addressManager.deployed();

    await addressManager.setAddress("AddRH", verifierAddRH.address);
    await addressManager.setAddress("PMul1", verifierPMul1.address);

    const CosmosValidators = await ethers.getContractFactory("CosmosValidators");
    const cosmosValidators = await upgrades.deployProxy(CosmosValidators, [addressManager.address, 1, 3, _validatorSet])
    // console.log(await cosmosValidators.verifyAddRHProof(_AddRHProof));
    // console.log(await cosmosValidators.verifyCalculatePointMulProof(_PMul1Proof));
    console.log(await cosmosValidators.verifySignaturesHeader(_validatorSet, [_AddRHProof, _AddRHProof, _AddRHProof], [_PMul1Proof, _PMul1Proof, _PMul1Proof]))
}

const _validatorSet = [["0xFD284E309E23A18641A8F545B43D3EB24539F65061F38B80C8B92678BE83A70A", 200159], ["0xFD284E309E23A18641A8F545B43D3EB24539F65061F38B80C8B92678BE83A70A", 200159], ["0xFD284E309E23A18641A8F545B43D3EB24539F65061F38B80C8B92678BE83A70A", 200159]]
const _AddRHProof = ["AddRH", ["0x275850731674688fd0a9afda08a304fc1c5835bc3973622aeb8dca259a7c1844", "0x2f3a27f7bf2e853c7f8d020c6bc4e5f5c068dad6f5d21cd3cecb908fbf8d0bb3"], [["0x06220a32a42f2264645ff520957ce86b057aa40a0ef1213d77df654db0d506be", "0x03a20890217ccd47ca62922c40ce60d07d3c94781979be60e94902efd834a9b4"], ["0x04c3b796d18cfc9d28333ba8c19a834009103006dbca06b73ffb42ec0e8009b8", "0x2e847bab0ec0db104ec4139c93c54d5036d750e0d1314f352ee97cd132036f43"]], ["0x27e6529bdf801f56e8413fae91d8a92c5377ef1725a5f5fb2b8cd5d72c6c6599", "0x284236a4daa39b10b85922b6db73f776cac37fa467bcd95f7e3d6ac50f12f8c2"], ["0x000000000000000000000000000000000000000000185f2d4b7d85774e7308e4", "0x000000000000000000000000000000000000000000043584471c299c0e55041d", "0x000000000000000000000000000000000000000000047a102eaccd02c6e87ba0", "0x000000000000000000000000000000000000000000044cb97f7db17784b81845", "0x0000000000000000000000000000000000000000000bab9573cfc8313c063721", "0x0000000000000000000000000000000000000000000796bb3b888a12db094fa8", "0x00000000000000000000000000000000000000000019ef23b718d54ee0c7f1a9", "0x0000000000000000000000000000000000000000000ee58c0dcdd7bb84fa28ff", "0x00000000000000000000000000000000000000000016e50f46d62835836c0001", "0x00000000000000000000000000000000000000000004e0e96989aea8b2eecd6f", "0x0000000000000000000000000000000000000000001515a6443cb1d7e1965413", "0x00000000000000000000000000000000000000000016e1d44591560c0a271e84"], [253, 40, 78, 48, 158, 35, 161, 134, 65, 168, 245, 69, 180, 61, 62, 178, 69, 57, 246, 80, 97, 243, 139, 128, 200, 185, 38, 120, 190, 131, 167, 10], [29, 199, 36, 178, 84, 166, 115, 76, 30, 71, 15, 32, 51, 147, 51, 1, 30, 66, 149, 118, 179, 245, 1, 108, 92, 133, 123, 255, 26, 191, 209, 137], [110, 8, 2, 17, 197, 198, 157, 0, 0, 0, 0, 0, 34, 72, 10, 32, 221, 176, 16, 254, 205, 166, 67, 239, 182, 231, 240, 251, 203, 176, 164, 171, 127, 35, 23, 63, 134, 91, 64, 237, 244, 113, 57, 163, 98, 126, 18, 0, 18, 36, 8, 1, 18, 32, 28, 66, 108, 220, 131, 113, 179, 106, 254, 145, 161, 129, 136, 18, 8, 121, 3, 179, 92, 111, 198, 239, 153, 141, 25, 255, 45, 207, 110, 250, 0, 165, 42, 12, 8, 228, 139, 196, 159, 6, 16, 179, 137, 182, 245, 1, 50, 9, 79, 114, 97, 105, 99, 104, 97, 105, 110]]
const _PMul1Proof = ["PMul1", ["0x059a686a5265e1d26aa69962c32638ba64bd10cb11605cfe05ba58a47b5cde17", "0x2580abba198a4884666e4776f4bed4fc640ea9f0016cb53d3d8f13f7fde30c00"], [["0x28eb7817308fbdb1898830f6e5c576f4ff1c27a5374c26a551897071e1162917", "0x09dd217e6e5bec3b6dd8bc9e4d347e0f9071cd9ad277f2a4f4b15ad35b7b7f97"], ["0x202eb83b23e0830880e0c763246d5bcaa56111876636c7e40bd38491d0be5857", "0x2a70731f70df0a51476e2bd48cdfb1ab2ec17813ea6218030e94eb523159be60"]], ["0x10c69fd2bb53b78ac14e99a9053f61613310e3d3aefaf8e1bbae2c1b8054d4bf", "0x0fe7d2e86bef4f899c9e05285c776308d5c0a871e58040aff841664108c2f81f"], [204, 46, 245, 69, 46, 84, 169, 94, 155, 240, 248, 97, 172, 191, 212, 248, 191, 204, 117, 38, 12, 181, 189, 199, 208, 109, 101, 68, 129, 167, 97, 4]]

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });


