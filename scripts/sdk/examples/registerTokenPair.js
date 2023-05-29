const { getAddresFromAsciiString } = require("../../utils/helper");
const {registerTokenPair} = require("../oraisan-bridge")

require("dotenv").config();

const main = async () => {
   ethToken = await registerTokenPair(getAddresFromAsciiString(process.env.COSMOS_TOKEN), process.env.ETH_TOKEN);
   console.log("cosmosToken: ", getAddresFromAsciiString(process.env.COSMOS_TOKEN), " <-> ", "ethToken: ", ethToken);
};

main()
  .then(() => {})
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
