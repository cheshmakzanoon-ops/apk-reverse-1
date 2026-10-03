local ActLotteryPreOpenReward = {
  Name = UIWindowNames.ActLotteryPreOpenReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActLottery.ActLotteryPreOpenReward.Controller.ActLotteryPreOpenRewardCtrl"),
  View = require("UI.UIActLottery.ActLotteryPreOpenReward.View.ActLotteryPreOpenRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActLottery/ActLotteryPreOpenReward.prefab",
  CustomKeyCodeEscape = true
}
return {ActLotteryPreOpenReward = ActLotteryPreOpenReward}
