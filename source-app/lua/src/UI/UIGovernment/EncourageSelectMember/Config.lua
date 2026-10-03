local UIGovernmentEncourageSelectMember = {
  Name = UIWindowNames.UIGovernmentEncourageSelectMember,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.EncourageSelectMember.Controller.EncourageSelectMemberCtrl"),
  View = require("UI.UIGovernment.EncourageSelectMember.View.EncourageSelectMemberView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/EncourageSelectMember.prefab"
}
return {UIGovernmentEncourageSelectMember = UIGovernmentEncourageSelectMember}
