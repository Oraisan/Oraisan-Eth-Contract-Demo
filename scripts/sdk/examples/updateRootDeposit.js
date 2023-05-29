const {updateRootDepositTree} = require("../oraisan-bridge")

require("dotenv").config();

const main = async () => {
  
   let root = await updateRootDepositTree("./resources/verifyRootDeposit/public.json", "./resources/verifyRootDeposit/proof.json");
   console.log("RootDeposit", root);
};

main()
  .then(() => {})
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
