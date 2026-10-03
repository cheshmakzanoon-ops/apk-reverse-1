local UISeasonOfficialEncourageSelect = {
  Name = UIWindowNames.UISeasonOfficialEncourageSelect,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialEncourageSelect.UISeasonOfficialEncourageSelectCtrl"),
  View = require("UI.UIGovernment.UISeasonOfficialEncourageSelect.UISeasonOfficialEncourageSelectView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialEncourageSelect.prefab"
}
return {UISeasonOfficialEncourageSelect = UISeasonOfficialEncourageSelect}
