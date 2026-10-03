local UISeasonOfficialApply = {
  Name = UIWindowNames.UISeasonOfficialApply,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialApply.UISeasonOfficialApplyCtrl"),
  View = require("UI.UIGovernment.UISeasonOfficialApply.UISeasonOfficialApplyView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialApply.prefab"
}
return {UISeasonOfficialApply = UISeasonOfficialApply}
