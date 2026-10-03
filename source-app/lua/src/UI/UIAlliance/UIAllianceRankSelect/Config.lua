local UIAllianceRankSelect = {
  Name = UIWindowNames.UIAllianceRankSelect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceRankSelect.Controller.UIAllianceRankSelectCtrl"),
  View = require("UI.UIAlliance.UIAllianceRankSelect.View.UIAllianceRankSelectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceRankSelect.prefab"
}
return {UIAllianceRankSelect = UIAllianceRankSelect}
