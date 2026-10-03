local UIFormationDefenceTable = {
  Name = UIWindowNames.UIFormationDefenceTable,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFormationDefence.UIFormationDefenceTable.Controller.UIFormationDefenceTableCtrl"),
  View = require("UI.UIFormationDefence.UIFormationDefenceTable.View.UIFormationDefenceTableView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFormationDefence/UIFormationDefenceTable.prefab"
}
return {UIFormationDefenceTable = UIFormationDefenceTable}
