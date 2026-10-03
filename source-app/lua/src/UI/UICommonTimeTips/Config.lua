local UICommonTips = {
  Name = UIWindowNames.UICommonTimeTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonTimeTips.Controller.UICommonTimeTipsCtrl"),
  View = require("UI.UICommonTimeTips.View.UICommonTimeTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonTimeTips.prefab"
}
return {UICommonTips = UICommonTips}
