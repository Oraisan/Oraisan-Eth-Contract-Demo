const {updateRootDepositTree, claimTransaction} = require("../oraisan-bridge")

require("dotenv").config();

const main = async () => {
  
   let res = await claimTransaction("./resources/verifyClaimTransaction/public.json", "./resources/verifyClaimTransaction/proof.json");
   console.log("verifyClaimTransaction", res);
};

main()
  .then(() => {})
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
