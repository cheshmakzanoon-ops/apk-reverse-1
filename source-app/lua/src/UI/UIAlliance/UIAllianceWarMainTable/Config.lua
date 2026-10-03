local UIAllianceWarMainTable = {
  Name = UIWindowNames.UIAllianceWarMainTable,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceWarMainTable.Controller.UIAllianceWarMainTableCtrl"),
  View = require("UI.UIAlliance.UIAllianceWarMainTable.View.UIAllianceWarMainTableView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UILWAlWar.prefab",
  HideBack = true
}
return {UIAllianceWarMainTable = UIAllianceWarMainTable}
