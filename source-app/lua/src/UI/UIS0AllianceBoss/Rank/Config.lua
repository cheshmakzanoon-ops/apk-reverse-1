local UIS0AllianceBossRank = {
  Name = UIWindowNames.UIS0AllianceBossRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIS0AllianceBoss.Rank.UIS0AllianceBossRankCtrl"),
  View = require("UI.UIS0AllianceBoss.Rank.UIS0AllianceBossRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/S0AllianceBoss/UIS0AllianceBossRankPopUp.prefab"
}
return {UIS0AllianceBossRank = UIS0AllianceBossRank}
