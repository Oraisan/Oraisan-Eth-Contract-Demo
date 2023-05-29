const { getAddresFromAsciiString } = require("../../utils/helper");
const {registerCosmosBridge} = require("../oraisan-bridge")

require("dotenv").config();

const main = async () => {
   const isSupportBridge = await registerCosmosBridge(getAddresFromAsciiString(process.env.COSMOS_BRIDGE), true);
   console.log("isSupportBridge: ", isSupportBridge);
};

main()
  .then(() => {})
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
