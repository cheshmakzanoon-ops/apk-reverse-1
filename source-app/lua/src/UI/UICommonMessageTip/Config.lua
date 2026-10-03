local UICommonMessageTip = {
  Name = UIWindowNames.UICommonMessageTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UICommonMessageTip.Controller.UICommonMessageTipCtrl"),
  View = require("UI.UICommonMessageTip.View.UICommonMessageTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/UICommonMessageTip.prefab"
}
return {UICommonMessageTip = UICommonMessageTip}
