const { deployLib_AddressManager } = require("./deploy");

async function main () {
  await deployLib_AddressManager();
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

  