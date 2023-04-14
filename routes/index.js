const { Router } = require("express");
const router = Router();

const newBlockHeaderRoutes = require("./newBlockHeader.routes.js");

/* GET home page. */
router.use("/newBlockHeader", newBlockHeaderRoutes);

module.exports = router;
