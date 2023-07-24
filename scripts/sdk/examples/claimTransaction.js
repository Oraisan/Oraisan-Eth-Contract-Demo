const {claimTransaction} = require("../oraisan-bridge")
const {getTokenBalance} = require("../eth-token")

require("dotenv").config();

const main = async () => {
  
   await claimTransaction("./resources/verifyClaimTransaction/public.json", "./resources/verifyClaimTransaction/proof.json");
   console.log("tokenBalance", await getTokenBalance(process.env.PUBLIC_KEY));
};

main()
  .then(() => {})
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
