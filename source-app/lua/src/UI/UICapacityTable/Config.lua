local UICapacityTable = {
  Name = UIWindowNames.UICapacityTable,
  Layer = UILayer.Background,
  Ctrl = require("UI.UICapacityTable.Controller.UICapacityTableCtrl"),
  View = require("UI.UICapacityTable.View.UICapacityTableView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICapacity/UICapacityTable.prefab"
}
return {UICapacityTable = UICapacityTable}
