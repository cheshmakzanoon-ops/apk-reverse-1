local UILWCommonShowBubbleTip = {
  Name = UIWindowNames.UILWCommonShowBubbleTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UILWCommonShowBubbleTip.Controller.CommonShowBubbleTipCtrl"),
  View = require("UI.UILWCommonShowBubbleTip.View.CommonShowBubbleTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Common/CommonShowBubbleTip.prefab"
}
return {UILWCommonShowBubbleTip = UILWCommonShowBubbleTip}
