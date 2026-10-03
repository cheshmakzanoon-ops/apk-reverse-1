local UIChatGroupSelectMember = {
  Name = UIWindowNames.UIChatGroupSelectMember,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatGroupSelectMember.Ctrl.UIChatGroupSelectMemberCtrl"),
  View = require("UI.UIChatGroupSelectMember.View.UIChatGroupSelectMemberView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/GroupChat/UIChatGroupSelectMember.prefab"
}
return {UIChatGroupSelectMember = UIChatGroupSelectMember}
