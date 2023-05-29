const fs = require("fs");
const { setLib_AddressManager } = require("../libAddressManager");
require("dotenv").config();

const main = async () => {
  const Contract = [
    // "ORAISAN_GATE",
    // "ORAISAN_BRIDGE",
    "COSMOS_BLOCK_HEADER",
    // "COSMOS_VALIDATORS",
    // "VERIFIER_VALIDATOR_SIGNATURE",
    // "VERIFIER_VALIDATORS_LEFT",
    // "VERIFIER_VALIDATORS_RIGHT",
    // "VERIFIER_ROOT_DEPOSIT",
    // "VERIFIER_CLAIM_TRANSACTION",
    // "ETH_TOKEN"
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
