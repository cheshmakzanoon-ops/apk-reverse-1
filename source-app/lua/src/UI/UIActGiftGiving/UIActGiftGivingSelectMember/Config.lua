local UIActGiftGivingSelectMember = {
  Name = UIWindowNames.UIActGiftGivingSelectMember,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActGiftGiving.UIActGiftGivingSelectMember.Controller.UIActGiftGivingSelectMemberCtrl"),
  View = require("UI.UIActGiftGiving.UIActGiftGivingSelectMember.View.UIActGiftGivingSelectMemberView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActGiftGiving/UIActGiftGivingSelectMember.prefab"
}
return {UIActGiftGivingSelectMember = UIActGiftGivingSelectMember}
