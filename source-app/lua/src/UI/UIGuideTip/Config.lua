local UIGuideTip = {
  Name = UIWindowNames.UIGuideTip,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIGuideTip.Controller.UIGuideTipCtrl"),
  View = require("UI.UIGuideTip.View.UIGuideTipView"),
  PrefabPath = "Assets/Main/Prefabs/Guide/UIGuideTip.prefab"
}
return {UIGuideTip = UIGuideTip}
