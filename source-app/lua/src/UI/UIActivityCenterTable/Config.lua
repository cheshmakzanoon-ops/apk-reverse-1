local UIActivityCenterTable = {
  Name = UIWindowNames.UIActivityCenterTable,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Controller.UIActivityCenterTableCtrl"),
  View = require("UI.UIActivityCenterTable.View.UIActivityCenterTableView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UIActivityCenterTableNew.prefab",
  HideBack = true
}
return {UIActivityCenterTable = UIActivityCenterTable}
