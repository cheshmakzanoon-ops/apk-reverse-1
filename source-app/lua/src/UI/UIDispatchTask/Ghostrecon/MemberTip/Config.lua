local UIGhostreconMemberListTip = {
  Name = UIWindowNames.UIGhostreconMemberListTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Ghostrecon.MemberTip.Controller.UIGhostreconMemberListTipCtrl"),
  View = require("UI.UIDispatchTask.Ghostrecon.MemberTip.View.UIGhostreconMemberListTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Ghostrecon/Tip/UIGhostreconMemberListTip.prefab"
}
return {UIGhostreconMemberListTip = UIGhostreconMemberListTip}
