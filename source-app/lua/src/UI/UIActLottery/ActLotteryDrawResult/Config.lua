local ActLotteryDrawResult = {
  Name = UIWindowNames.ActLotteryDrawResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActLottery.ActLotteryDrawResult.Controller.ActLotteryDrawResultCtrl"),
  View = require("UI.UIActLottery.ActLotteryDrawResult.View.ActLotteryDrawResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActLottery/ActLotteryResult/ActLotteryDrawResult.prefab"
}
return {ActLotteryDrawResult = ActLotteryDrawResult}
