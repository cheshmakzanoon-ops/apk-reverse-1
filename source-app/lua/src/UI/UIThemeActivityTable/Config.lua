local UIThemeActivityTable = {
  Name = UIWindowNames.UIThemeActivityTable,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIThemeActivityTable.Controller.UIThemeActivityTableCtrl"),
  View = require("UI.UIThemeActivityTable.View.UIThemeActivityTableView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UIActivityCenterTableNew.prefab"
}
return {UIThemeActivityTable = UIThemeActivityTable}
