local UIPersonalArmsConvert = {
  Name = UIWindowNames.UIPersonalArmsConvert,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIPersonalArmsConvert.Controller.UIPersonalArmsConvertCtrl"),
  View = require("UI.UIPersonalArmsConvert.View.UIPersonalArmsConvertView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/UIPersonalArmsConvert.prefab"
}
return {UIPersonalArmsConvert = UIPersonalArmsConvert}
