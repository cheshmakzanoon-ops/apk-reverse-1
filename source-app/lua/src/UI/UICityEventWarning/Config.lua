local UILWCityEventWarningView = {
  Name = UIWindowNames.UILWCityEventWarningView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICityEventWarning.UILWCityEventWarningCtrl"),
  View = require("UI.UICityEventWarning.UILWCityEventWarningView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICityEvent/LWCityEventWarning.prefab"
}
return {UILWCityEventWarningView = UILWCityEventWarningView}
