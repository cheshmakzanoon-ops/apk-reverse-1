local UIGovernmentOfficialSelectMember = {
  Name = UIWindowNames.UIGovernmentOfficialSelectMember,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.OfficialSelectMember.Controller.OfficialSelectMemberCtrl"),
  View = require("UI.UIGovernment.OfficialSelectMember.View.OfficialSelectMemberView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/OfficialSelectMember.prefab"
}
return {UIGovernmentOfficialSelectMember = UIGovernmentOfficialSelectMember}
