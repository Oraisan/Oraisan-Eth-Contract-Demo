const {updateBlockHeader} = require("../oraisan-gate")

require("dotenv").config();

const main = async () => {
  
   let root = await updateBlockHeader("./resources/cosmosHeader/public.json", "./resources/cosmosHeader/proof.json");
   console.log("BlockHash", root);
};

main()
  .then(() => {})
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
