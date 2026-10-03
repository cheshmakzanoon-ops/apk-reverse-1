local UIVIPEffectTip = {
  Name = UIWindowNames.UIVIPEffectTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIVip.UIVIPEffectTip.Controller.UIVIPEffectTipCtrl"),
  View = require("UI.UIVip.UIVIPEffectTip.View.UIVIPEffectTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWVIPPanel/UILWVIPEffectTip.prefab"
}
return {UIVIPEffectTip = UIVIPEffectTip}
