exports.hashLeaf = exports.hashInside = exports.calculateRootByLeafs = exports.calulateRootBySiblings = void 0;
const { rdOwnerAVL_Tree } = require("./rdOwner");
require("dotenv").config();

const hashLeaf = async (leaf) => {
    const rdOwner = await rdOwnerAVL_Tree();
    const hash = await rdOwner.hashLeaf(leaf);
    return hash;
}
exports.hashLeaf = hashLeaf;

const hashInside = async (leafLeft, leafRight) => {
    const rdOwner = await rdOwnerAVL_Tree();
    const hash = await rdOwner.hashInside(leafLeft, leafRight);
    return hash;
}
exports.hashInside = hashInside;

const calculateRootByLeafs = async (leafsArray) => {
    const rdOwner = await rdOwnerAVL_Tree();
    const root = await rdOwner.calculateRootByLeafs(leafsArray);
    return root;
}
exports.calculateRootByLeafs = calculateRootByLeafs;

const calulateRootBySiblings = async (index, total, leaf, siblings) => {
    const rdOwner = await rdOwnerAVL_Tree();
    const root = await rdOwner.calulateRootBySiblings(index, total, leaf, siblings);
    return root;
}
exports.calulateRootBySiblings = calulateRootBySiblings;
