local UISeasonOfficialSelectMember = {
  Name = UIWindowNames.UISeasonOfficialSelectMember,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialSelectMember.UISeasonOfficialSelectMemberCtrl"),
  View = require("UI.UIGovernment.UISeasonOfficialSelectMember.UISeasonOfficialSelectMemberView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialSelectMember.prefab"
}
return {UISeasonOfficialSelectMember = UISeasonOfficialSelectMember}
