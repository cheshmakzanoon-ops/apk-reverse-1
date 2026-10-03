local LWGuideMask = {
  Name = UIWindowNames.LWGuideMask,
  Layer = UILayer.Guide,
  Ctrl = require("UI.LWGuideMask.Controller.LWGuideMaskCtrl"),
  View = require("UI.LWGuideMask.View.LWGuideMaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGuideMask/UIGuideMask.prefab",
  CustomKeyCodeEscape = true
}
return {LWGuideMask = LWGuideMask}
