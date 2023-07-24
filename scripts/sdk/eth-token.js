const { rdOwnerERC20Token } = require("./rdOwner");
require("dotenv").config();

const getTokenBalance = async (sender) => {
    const rdOwner = await rdOwnerERC20Token();
    const res = await rdOwner.balanceOf(sender);
    return res;
}
exports.getTokenBalance = getTokenBalance;