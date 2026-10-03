local UILLGroupInvitation = {
  Name = UIWindowNames.UILLGroupInvitation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Landlord.GroupInvitation.Ctrl.UILLGroupInvitationCtrl"),
  View = require("UI.Landlord.GroupInvitation.View.UILLGroupInvitationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/LLGroupInvitationPanel.prefab"
}
return {UILLGroupInvitation = UILLGroupInvitation}
