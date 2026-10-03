local UIActLotteryItemGetManual = {
  Name = UIWindowNames.UIActLotteryItemGetManual,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActLottery.UIActLotteryItemGetManual.Ctrl.UIActLotteryItemGetManualCtrl"),
  View = require("UI.UIActLottery.UIActLotteryItemGetManual.View.UIActLotteryItemGetManualView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActLottery/UIActLotteryItemGetManual.prefab"
}
return {UIActLotteryItemGetManual = UIActLotteryItemGetManual}
