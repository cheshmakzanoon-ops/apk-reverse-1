local UIRecruitLotteryTip = {
  Name = UIWindowNames.UIRecruitLotteryTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIHero2.UIRecruitLotteryTip.Controller.UIRecruitLotteryTipCtrl"),
  View = require("UI.UIHero2.UIRecruitLotteryTip.View.UIRecruitLotteryTip"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIRecruitLotteryTip.prefab"
}
return {UIRecruitLotteryTip = UIRecruitLotteryTip}
