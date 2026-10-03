local UIGhostreconGiftTip = {
  Name = UIWindowNames.UIGhostreconGiftTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Ghostrecon.GiftTip.Controller.UIGhostreconGiftTipCtrl"),
  View = require("UI.UIDispatchTask.Ghostrecon.GiftTip.View.UIGhostreconGiftTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Ghostrecon/Tip/UIGhostreconGiftTip.prefab"
}
return {UIGhostreconGiftTip = UIGhostreconGiftTip}
