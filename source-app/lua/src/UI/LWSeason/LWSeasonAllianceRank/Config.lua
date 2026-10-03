local LWSeasonAllianceRank = {
  Name = UIWindowNames.LWSeasonAllianceRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonAllianceRank.Controller.LWSeasonAllianceRankCtrl"),
  View = require("UI.LWSeason.LWSeasonAllianceRank.View.LWSeasonAllianceRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonAllianceRank.prefab"
}
return {LWSeasonAllianceRank = LWSeasonAllianceRank}
