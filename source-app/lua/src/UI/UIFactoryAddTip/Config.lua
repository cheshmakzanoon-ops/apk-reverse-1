local UIFactoryAddTip = {
  Name = UIWindowNames.UIFactoryAddTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIFactoryAddTip.Controller.UIFactoryAddTipCtrl"),
  View = require("UI.UIFactoryAddTip.View.UIFactoryAddTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFactory/UIFactoryAddTip.prefab"
}
return {UIFactoryAddTip = UIFactoryAddTip}
