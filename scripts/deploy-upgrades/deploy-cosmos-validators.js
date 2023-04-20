const { ethers, upgrades } = require("hardhat");
require("dotenv").config();

const input = {
    lib_AddressManager: process.env.Lib_AddressManager,
    currentHeight: 10340037,
    validatorSet: [
        "0x81F27BDE6DCCB9FD90320231F1DA10B6E9FF6A03",
        "0x29EEC46389E07ED03BF3205887E25F9B3F379550",
        "0xB81456DD3E96886165F8B5895ED53201A575B682",
        "0x06CF27DEF0D3D7353894B01B7DCB2C1038C0F074",
        "0xAD1A1DB19D951A2DBDF710D73711872D85E7D50D",
        "0x87948C99D5E7B73CCA094893BE4E0E9F3C7508C9",
        "0x6F60391CD0B16B92350B99470D30AA602E228F02",
        "0x6D47F746299FE13AAAED50BA5C9B65C720419B7A",
        "0x11497DDE6D3E9D4C42136850EF1C6DBD021F3FBB",
        "0x8C4BF7429E8BD82587D733ED6C0D3798130F21D0",
        "0xEDE8D483E839C40BF52CC14E8C3E494BFB5B0B8B",
        "0xDAC18D4F4A57400F67B6E72E250E7C3D939EE707",
        "0x0044661CF0D7BEC86629957C7403A7D435EF08CA",
        "0x1A0D64DEC769B881525C951727AE30C8ABAFDDDE",
        "0x6B1721708D4AFEC4C4CD7544455C4A17452BB5DF",
        "0x19744E2806D57821A9D24231A513CDC1CCE308D1",
        "0x0B33797E084F287D31AB7D5E79DFED79BC50F95C",
        "0x1EF387941DB08584FCE3637BC92E0D688CFC40E7",
        "0xBED2B8EA7447DDF0D180179A05B1F0689FD53D86",
        "0x0BDC699EF20C95A99B746A8F7F18D35E2AAF0C3D",
        "0x2FF1CB754F08DDA69CF6EDB68C228E11DFDB1DE1",
        "0xBE17E553E945D33DA9327340D1EAB4CE435250F8",
        "0xC93AE16606815AE207F96BCD87A35A5BB7C91795",
        "0x3C011275CA87F5613DB8A09EE284118F32B1A805",
        "0x39635BFF8DDB2B64E75C8A69A3E0B4E2A6882B9A",
        "0xE0B81F8AEE951C230A30596675827AD5FE8530D6",
        "0x7624A794B904CA6B1FD927400367403D54F54C3E",
        "0x36FD665E5F1883C947E7A3837EF0F197B1C53E14",
        "0xECA548CD73C2FAC53BC9F6A6A891E7D59C8C3B8D",
        "0x0D85BF7C6239A7592692B309BF5CB3B26393BA94",
        "0x71EA529AD391F92EE3EC6EB9E382333C915BD33F",
        "0x20E025D573C4343AA61973411FDA4C3AFF4B575F",
        "0xDB0F52D72A98E935268F5754E0BC22E98A271A2A",
        "0xC3ED8389D8BC1B26121FAAA1B15EC047173B38E8",
        "0xD6A4D7C7670C5B5DCF2EFB9694811A76B4B21E66",
        "0x868644AB8794E3C931A9C878DD35593FA339D9A4",
        "0x750FC2889EC79A1F07AEE5621CCCC9537BADE48E",
        "0x7379C67D69963578AD8C7B2F159AA60E911E03A8",
        "0x72E4B7A1613764158EA2273002C716D601394359",
        "0x68F37285B543B655B26528FD8809279C20632BE1",
        "0x664BD44925A815FA988CF0ADBF923EAC93538AA9",
        "0xB9EABA180D3D0675832AD1C22EE07FBDA136CABB",
        "0x7CFCBF61A3348144ACF584BD2F2A44941CE64685",
        "0x56DB08D312103AA8446A71B2B5B3B065D910FB09",
        "0xE6B770673E6662E75B3F5C0802F6025D99EBF2E5",
        "0x59A6CA381B728B4A05BB04C2625BA921DED7E623"
    ]
}
const main = async () => {
    const CosmosValidators = await ethers.getContractFactory("CosmosValidators");
    const cosmosValidators = await upgrades.deployProxy(CosmosValidators,
        [
            input.lib_AddressManager,
            input.currentHeight,
            input.validatorSet
        ]);
    await cosmosValidators.deployed();
    console.log("CosmosValidators dedployed at: ", cosmosValidators.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

