const { rdOwnerERC20Token } = require("./rdOwner");
require("dotenv").config();

const getTokenBalance = async (sender) => {
    const rdOwner = await rdOwnerERC20Token();
    const res = await rdOwner.balanceOf(sender);
    return res;
}
exports.getTokenBalance = getTokenBalance;

const setBridgeAdmin = async (eth_bridge) => {
    // console.log(input)
    const rdOwner = await rdOwnerERC20Token();

    const res = await rdOwner.setBridgeAdmin(eth_bridge,
        { gasLimit: 2e6 }
        );
    await res.wait();
    return (await rdOwner.getEthBridge());
}
exports.setBridgeAdmin = setBridgeAdmin;