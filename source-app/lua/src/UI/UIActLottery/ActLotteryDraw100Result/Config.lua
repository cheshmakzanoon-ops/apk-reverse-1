local ActLotteryDraw100Result = {
  Name = UIWindowNames.ActLotteryDraw100Result,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActLottery.ActLotteryDraw100Result.Controller.ActLotteryDraw100ResultCtrl"),
  View = require("UI.UIActLottery.ActLotteryDraw100Result.View.ActLotteryDraw100ResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActLottery/ActLotteryResult/ActLotteryDraw100Result.prefab"
}
return {ActLotteryDraw100Result = ActLotteryDraw100Result}
