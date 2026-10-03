local UISeasonOfficialMail = {
  Name = UIWindowNames.UISeasonOfficialMail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialMail.UISeasonOfficialMailCtrl"),
  View = require("UI.UIGovernment.UISeasonOfficialMail.UISeasonOfficialMailView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialMail.prefab"
}
return {UISeasonOfficialMail = UISeasonOfficialMail}
