local UIHSRMain = {
  Name = UIWindowNames.UIHSRMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHSR.UIHSRMain.UIHSRMainCtrl"),
  View = require("UI.UIHSR.UIHSRMain.UIHSRMainView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/UIHSRMain.prefab",
  HideBack = true
}
return {UIHSRMain = UIHSRMain}
