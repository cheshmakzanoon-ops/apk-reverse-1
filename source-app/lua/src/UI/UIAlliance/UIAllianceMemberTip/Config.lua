local UIAllianceMemberTip = {
  Name = UIWindowNames.UIAllianceMemberTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAllianceMemberTip.Controller.UIAllianceMemberTipCtrl"),
  View = require("UI.UIAlliance.UIAllianceMemberTip.View.UIAllianceMemberTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAllianceMemberTip.prefab"
}
return {UIAllianceMemberTip = UIAllianceMemberTip}
