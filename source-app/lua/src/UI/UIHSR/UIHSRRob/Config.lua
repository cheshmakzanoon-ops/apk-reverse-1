local UIHSRRob = {
  Name = UIWindowNames.UIHSRRob,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHSR.UIHSRRob.UIHSRRobCtrl"),
  View = require("UI.UIHSR.UIHSRRob.UIHSRRobView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/HSR/UIHSRRob.prefab",
  HideBack = true
}
return {UIHSRRob = UIHSRRob}
