const {
  newBlockHeaderController,
} = require("../controllers/newBlockHeader.controller");
const router = require("express").Router();

router.route("/").post(newBlockHeaderController);
router.route("/").get((req, res) => {
  res.send("Hello World!");
});

module.exports = router;
