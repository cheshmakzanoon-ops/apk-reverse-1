local UIFirstPayHeroTip = {
  Name = UIWindowNames.UIFirstPayHeroTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFirstPayHeroTip.Ctrl.UIFirstPayHeroTipCtrl"),
  View = require("UI.UIFirstPayHeroTip.View.UIFirstPayHeroTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFirstPay/UIFirstPayHeroTip.prefab"
}
return {UIFirstPayHeroTip = UIFirstPayHeroTip}
