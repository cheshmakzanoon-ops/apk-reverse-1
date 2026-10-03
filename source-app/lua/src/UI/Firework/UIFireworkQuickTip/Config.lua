local UIFireworkQuickTip = {
  Name = UIWindowNames.UIFireworkQuickTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Firework.UIFireworkQuickTip.Controller.UIFireworkQuickTipCtrl"),
  View = require("UI.Firework.UIFireworkQuickTip.View.UIFireworkQuickTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIFirework/UIFireworkQuickTip.prefab"
}
return {UIFireworkQuickTip = UIFireworkQuickTip}
