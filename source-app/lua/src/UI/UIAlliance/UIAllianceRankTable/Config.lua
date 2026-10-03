local UIAllianceRankTable = {
  Name = UIWindowNames.UIAllianceRankTable,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceRankTable.Controller.UIAllianceRankTableCtrl"),
  View = require("UI.UIAlliance.UIAllianceRankTable.View.UIAllianceRankTableView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceRankTable.prefab"
}
return {UIAllianceRankTable = UIAllianceRankTable}
