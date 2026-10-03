local UICommonTips = {
  Name = UIWindowNames.UICommonTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonTips.Controller.UICommonTipsCtrl"),
  View = require("UI.UICommonTips.View.UICommonTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonTips.prefab"
}
return {UICommonTips = UICommonTips}
