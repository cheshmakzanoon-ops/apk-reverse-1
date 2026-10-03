local UIVip18EnvelopConfig = {
  Name = UIWindowNames.UIVip18Envelop,
  Layer = UILayer.Normal,
  View = require("UI.UIVipExtend.Vip18.UIVip18Envelop.View.UIVip18EnvelopView"),
  Ctrl = require("UI.UIVipExtend.Vip18.UIVip18Envelop.Ctrl.UIVip18EnvelopCtrl"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIVipExtend/UIVip18Envelop.prefab"
}
return {UIVip18Envelop = UIVip18EnvelopConfig}
