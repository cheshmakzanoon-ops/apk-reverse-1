local UILWMailEffectTip = {
  Name = UIWindowNames.UILWMailEffectTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWMail.UILWMailEffectTip.Controller.UILWMailEffectTipCtrl"),
  View = require("UI.UILWMail.UILWMailEffectTip.View.UILWMailEffectTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMail/UILWMailEffectTip.prefab"
}
return {UILWMailEffectTip = UILWMailEffectTip}
