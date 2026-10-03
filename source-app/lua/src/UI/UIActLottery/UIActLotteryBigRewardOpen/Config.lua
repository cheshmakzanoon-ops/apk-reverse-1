local UIActLotteryBigRewardOpen = {
  Name = UIWindowNames.UIActLotteryBigRewardOpen,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActLottery.UIActLotteryBigRewardOpen.Controller.UIActLotteryBigRewardOpenCtrl"),
  View = require("UI.UIActLottery.UIActLotteryBigRewardOpen.View.UIActLotteryBigRewardOpenView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActLottery/UIActLotteryBigRewardOpen.prefab",
  CustomKeyCodeEscape = true
}
return {UIActLotteryBigRewardOpen = UIActLotteryBigRewardOpen}
