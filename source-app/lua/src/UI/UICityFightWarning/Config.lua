local UICityFightWarning = {
  Name = UIWindowNames.UICityFightWarning,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICityFightWarning.LWCityFightWarningCtrl"),
  View = require("UI.UICityFightWarning.LWCityFightWarningView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICityEvent/LWCityFightWarning.prefab"
}
return {UICityFightWarning = UICityFightWarning}
