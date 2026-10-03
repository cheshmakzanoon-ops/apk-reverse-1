local ActLotteryBigRewardSpecialShow = {
  Name = UIWindowNames.ActLotteryBigRewardSpecialShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActLottery.ActLotteryBigRewardSpecialShow.Controller.ActLotteryBigRewardSpecialShowCtrl"),
  View = require("UI.UIActLottery.ActLotteryBigRewardSpecialShow.View.ActLotteryBigRewardSpecialShowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActLottery/ActLotteryBigRewardSpecialShow.prefab",
  CustomKeyCodeEscape = true
}
return {ActLotteryBigRewardSpecialShow = ActLotteryBigRewardSpecialShow}
