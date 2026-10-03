local UISeasonOfficialEncourage = {
  Name = UIWindowNames.UISeasonOfficialEncourage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialEncourage.UISeasonOfficialEncourageCtrl"),
  View = require("UI.UIGovernment.UISeasonOfficialEncourage.UISeasonOfficialEncourageView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialEncourage.prefab",
  HideBack = true
}
return {UISeasonOfficialEncourage = UISeasonOfficialEncourage}
