const fs = require("fs");
const { getProofValidatorSignature } = require("../scripts/utils/getProof");
const main = async () => {
    const path = "test/example_inputs/validatorSignature/";
    const inputProof = await getProofValidatorSignature(path + "public.json", path + "proof.json");

    const json = JSON.stringify(inputProof, null, 2);

    fs.writeFile(path + "inputProof.json", json, (err) => {
        if (err) {
            console.log(err);
        } else {
            console.log("write successful: " + path + "inputProof.json");
        }
    });

    console.log("inputProof:", inputProof);
}

main()
    .then(() => { })
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
