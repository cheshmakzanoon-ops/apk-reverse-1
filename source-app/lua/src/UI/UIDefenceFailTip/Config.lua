local UIDefenceFailTip = {
  Name = UIWindowNames.UIDefenceFailTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDefenceFailTip.Controller.UIDefenceFailTipCtrl"),
  View = require("UI.UIDefenceFailTip.View.UIDefenceFailTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIDefenceFailTip/UIDefenceFailTip.prefab"
}
return {UIDefenceFailTip = UIDefenceFailTip}
