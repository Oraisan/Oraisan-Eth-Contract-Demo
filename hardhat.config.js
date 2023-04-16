/**
 * @type import('hardhat/config').HardhatUserConfig
 */
// require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-waffle");
require("@ethersproject/abstract-provider");
require("@ethersproject/abstract-signer");
require("@ethersproject/transactions");
// require("@ethersproject/bytes");
// require("@truffle/hdwallet-provider");
require("@openzeppelin/hardhat-upgrades");
require("dotenv").config();

const DEFAULT_MNEMONIC =
  "explain tackle mirror kit van hammer degree position ginger unfair soup bonus";
const INFURA_URL =
  "https://rinkeby.infura.io/v3/05ef08be7bec4c9eb35821bd02018d19";
const KOVAN_URL = "https://kovan.infura.io/v3/ba63b223746842d89619ef053b179319";
const GOERLI_URL =
  "https://goerli.infura.io/v3/ba63b223746842d89619ef053b179319";
const PRIVATE_KEY = process.env.PRIVATE_KEY;

module.exports = {
  solidity: "0.8.4",
  settings: {
    optimizer: {
      enabled: true,
      runs: 1,
    },
  },

  defaultNetwork: "bscTestnet",
  networks: {
    hardhat: {
      allowUnlimitedContractSize: true,
      // blockGasLimit: 5420003048,
      accounts: [
        {
          privateKey:
            "36f1ea3519a6949576c242d927dd0c74650554cdfaedbcd03fb3a80c558c03de",
          balance: "100000000000000000000000000000",
        },
      ],
      // gasPrice: 5000000000,
      // gas: 5000000000,
      // gas: 25e6,
    },
    bscTestnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      chainId: 97,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    rinkeby: {
      url: INFURA_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    kovan: {
      url: KOVAN_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    goerli: {
      url: GOERLI_URL,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
};
