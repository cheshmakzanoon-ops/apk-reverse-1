local UIAllianceMainTable = {
  Name = UIWindowNames.UIAllianceMainTable,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceMainTable.Controller.UIAllianceMainTableCtrl"),
  View = require("UI.UIAlliance.UIAllianceMainTable.View.UIAllianceMainTableView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceMainTable.prefab"
}
return {UIAllianceMainTable = UIAllianceMainTable}
