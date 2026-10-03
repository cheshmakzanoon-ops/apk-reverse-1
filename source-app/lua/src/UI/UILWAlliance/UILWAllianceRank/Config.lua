local UILWAllianceRank = {
  Name = UIWindowNames.UILWAllianceRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWAlliance.UILWAllianceRank.Controller.UILWAllianceRankCtrl"),
  View = require("UI.UILWAlliance.UILWAllianceRank.View.UILWAllianceRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlRankPanel.prefab"
}
return {UILWAllianceRank = UILWAllianceRank}
