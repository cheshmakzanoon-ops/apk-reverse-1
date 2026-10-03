local UIMainMapPointToSelect = {
  Name = UIWindowNames.UIMainMapPointToSelect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMainMapPointToSelect.Controller.UIMainMapPointToSelectCtrl"),
  View = require("UI.UIMainMapPointToSelect.View.UIMainMapPointToSelectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMainUI/UIMainMapPointToSelect.prefab",
  CustomKeyCodeEscape = true
}
return {UIMainMapPointToSelect = UIMainMapPointToSelect}
