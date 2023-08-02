const {setBridgeAdmin} = require("../eth-token")
require("dotenv").config();

const main = async () => {
    const bridge_admin = await setBridgeAdmin(process.env.ORAISAN_BRIDGE)
    console.log("bridge_admin: ", bridge_admin);
};

main()
    .then(() => { })
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
