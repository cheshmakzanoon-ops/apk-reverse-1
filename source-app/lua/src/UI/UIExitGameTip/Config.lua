local UIExitGameTip = {
  Name = UIWindowNames.UIExitGameTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIExitGameTip.Controller.UIExitGameTipCtrl"),
  View = require("UI.UIExitGameTip.View.UIExitGameTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UIExitGameTip.prefab"
}
return {UIExitGameTip = UIExitGameTip}
