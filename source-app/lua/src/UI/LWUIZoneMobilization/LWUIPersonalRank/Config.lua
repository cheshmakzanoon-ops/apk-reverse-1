local LWUIZoneMobilizationPersonalRank = {
  Name = UIWindowNames.LWUIZoneMobilizationPersonalRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIZoneMobilization.LWUIPersonalRank.Controller.LWUIZoneMobilizationPersonalRankCtrl"),
  View = require("UI.LWUIZoneMobilization.LWUIPersonalRank.View.LWUIZoneMobilizationPersonalRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIZoneMobilization/LWUIZoneMobilizationPersonalRankPanel.prefab"
}
return {LWUIZoneMobilizationPersonalRank = LWUIZoneMobilizationPersonalRank}
