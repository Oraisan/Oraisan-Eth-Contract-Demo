
const fs = require("fs");
const { verifyProof, addIdentity } = require("../scripts/sdk/kyc");
const { setLib_AddressManager, getLib_AddressManager } = require("../scripts/sdk/libAddressManager");
require("dotenv").config();

/**
 * Check root claim and revoke before verify
 */
const main = async () => {
    const path = "test/example_inputs/addRH/";

    let addVerifierAddRH;
    if(!(await getLib_AddressManager("ADDRH")) == process.env.ADDRH) {
         addVerifierAddRH = await setLib_AddressManager("ADDRH", process.env.ADDRH); 
    } else {
        addVerifierAddRH = process.env.AddRH;
    }
    console.log("Verifier AddRH: ", addVerifierAddRH);
    const proofInputJson = JSON.parse(fs.readFileSync(path + "inputProof.json").toString());
    console.log(proofInputJson)
    console.log(await verifyProof(proofInputJson));
}

main()
    .then(() => { })
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
