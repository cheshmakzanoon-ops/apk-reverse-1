local UILLTaskBarTip = {
  Name = UIWindowNames.UILLTaskBarTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Landlord.Tip.Ctrl.UILLTaskBarTipCtrl"),
  View = require("UI.Landlord.Tip.View.UILLTaskBarTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/LLTaskBarTip.prefab"
}
return {UILLTaskBarTip = UILLTaskBarTip}
