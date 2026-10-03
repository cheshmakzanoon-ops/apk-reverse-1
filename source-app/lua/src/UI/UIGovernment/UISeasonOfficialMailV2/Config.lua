local UISeasonOfficialMailV2 = {
  Name = UIWindowNames.UISeasonOfficialMailV2,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialMailV2.UISeasonOfficialMailV2Ctrl"),
  View = require("UI.UIGovernment.UISeasonOfficialMailV2.UISeasonOfficialMailV2View"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialMailV2.prefab",
  HideBack = true
}
return {UISeasonOfficialMailV2 = UISeasonOfficialMailV2}
