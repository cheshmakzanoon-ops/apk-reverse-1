local UIWorldCollectMessageTip = {
  Name = UIWindowNames.UIWorldCollectMessageTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldCollect.UIWorldCollectMessageTip.Controller.UIWorldCollectMessageTipCtrl"),
  View = require("UI.UIWorldCollect.UIWorldCollectMessageTip.View.UIWorldCollectMessageTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISearch/UIWorldCollectMessageTip.prefab"
}
return {UIWorldCollectMessageTip = UIWorldCollectMessageTip}
