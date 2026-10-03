local UIActLotteryBeSendRewardGet = {
  Name = UIWindowNames.UIActLotteryBeSendRewardGet,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActLottery.UIActLotteryBeSendRewardGet.Controller.UIActLotteryBeSendRewardGetCtrl"),
  View = require("UI.UIActLottery.UIActLotteryBeSendRewardGet.View.UIActLotteryBeSendRewardGetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActLottery/UIActLotteryBeSendRewardGet.prefab"
}
return {UIActLotteryBeSendRewardGet = UIActLotteryBeSendRewardGet}
