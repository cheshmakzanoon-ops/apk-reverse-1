local UIChampionDuelDonateRewardTip = {
  Name = UIWindowNames.UIChampionDuelDonateRewardTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.UIChampionDuelDonateRewardTip.Controller.UIChampionDuelDonateRewardTipCtrl"),
  View = require("UI.UIChampionDuel.UIChampionDuelDonateRewardTip.View.UIChampionDuelDonateRewardTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelDonateRewardTip.prefab"
}
return {UIChampionDuelDonateRewardTip = UIChampionDuelDonateRewardTip}
