local UICommonUseResItemTips = {
  Name = UIWindowNames.UICommonUseResItemTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonUseResItemTips.Controller.UICommonUseResItemTipsCtrl"),
  View = require("UI.UICommonUseResItemTips.View.UICommonUseResItemTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonUseResItemTips.prefab"
}
return {UICommonUseResItemTips = UICommonUseResItemTips}
