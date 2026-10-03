local UICommonSideTip = {
  Name = UIWindowNames.UICommonSideTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICommonSideTip.Controller.UICommonSideTipCtrl"),
  View = require("UI.UICommonSideTip.View.UICommonSideTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICommonSideTip/UICommonSideTip.prefab"
}
return {UICommonSideTip = UICommonSideTip}
