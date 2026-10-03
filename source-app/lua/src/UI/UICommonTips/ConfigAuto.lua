local UICommonTipsAuto = {
  Name = UIWindowNames.UICommonTipsAuto,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonTips.Controller.UICommonTipsAutoCtrl"),
  View = require("UI.UICommonTips.View.UICommonTipsAutoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonTipsAuto.prefab"
}
return {UICommonTipsAuto = UICommonTipsAuto}
