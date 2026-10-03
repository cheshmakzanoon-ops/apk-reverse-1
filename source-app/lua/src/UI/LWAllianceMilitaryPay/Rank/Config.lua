local AllianceMilitaryPayRank = {
  Name = UIWindowNames.AllianceMilitaryPayRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWAllianceMilitaryPay.Rank.Ctrl.AllianceMilitaryPayRankCtrl"),
  View = require("UI.LWAllianceMilitaryPay.Rank.View.AllianceMilitaryPayRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/AllianceMilitaryPay/AllianceMilitaryPayRank.prefab"
}
return {AllianceMilitaryPayRank = AllianceMilitaryPayRank}
