const { newBlockHeaderService } = require("../services/newBlockHeader.service");

async function newBlockHeaderController(req, res) {
  console.log("huhu");
  const { data } = req.body;
  const result = await newBlockHeaderService(data);
  res.status(200).json(result);
}

module.exports = { newBlockHeaderController };
