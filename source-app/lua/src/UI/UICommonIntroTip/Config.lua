local UICommonIntroTip = {
  Name = UIWindowNames.UICommonIntroTip,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UICommonIntroTip.Controller.UICommonIntroTipCtrl"),
  View = require("UI.UICommonIntroTip.View.UICommonIntroTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonIntroTip.prefab"
}
return {UICommonIntroTip = UICommonIntroTip}
