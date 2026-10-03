local LWUIZoneMobilizationAllianceRank = {
  Name = UIWindowNames.LWUIZoneMobilizationAllianceRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIZoneMobilization.LWUIAllianceRank.Controller.LWUIZoneMobilizationAllianceRankCtrl"),
  View = require("UI.LWUIZoneMobilization.LWUIAllianceRank.View.LWUIZoneMobilizationAllianceRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIZoneMobilization/LWUIZoneMobilizationAllianceRankPanel.prefab"
}
return {LWUIZoneMobilizationAllianceRank = LWUIZoneMobilizationAllianceRank}
