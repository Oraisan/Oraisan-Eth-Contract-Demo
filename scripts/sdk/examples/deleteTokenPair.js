const { getAddresFromAsciiString } = require("../../utils/helper");
const {deleteTokenPair} = require("../oraisan-bridge")

require("dotenv").config();

const main = async () => {
   ethToken = await deleteTokenPair(getAddresFromAsciiString(process.env.COSMOS_TOKEN));
   console.log("cosmosToken: ", getAddresFromAsciiString(process.env.COSMOS_TOKEN), " <-> ", "ethToken: ", ethToken);
};

main()
  .then(() => {})
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
