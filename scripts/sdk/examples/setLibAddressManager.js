const fs = require("fs");
const { setLib_AddressManager } = require("../libAddressManager");
require("dotenv").config();

const main = async () => {
  const Contract = [
    "ORAISAN_GATE",
    "COSMOS_BLOCK_HEADER",
    "COSMOS_VALIDATORS",
    "AVL_TREE",
    "PROCESS_STRING",
    "VERIFIER_VALIDATOR_SIGNATURE_111",
    "VERIFIER_VALIDATOR_SIGNATURE_110",
    "VERIFIER_DATA_AND_VALS",
  ];
  let setAddress;
  for (let i = 0; i < Contract.length; i++) {
    setAddress = await setLib_AddressManager(
      Contract[i],
      process.env[Contract[i]]
    );
    console.log(Contract[i], setAddress);
  }
};

main()
  .then(() => {})
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
