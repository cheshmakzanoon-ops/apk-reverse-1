local UIComplexTip = {
  Name = UIWindowNames.UIComplexTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIComplexTip.Controller.UIComplexTipCtrl"),
  View = require("UI.UIComplexTip.View.UIComplexTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIComplexTip/UIComplexTip.prefab"
}
return {UIComplexTip = UIComplexTip}
