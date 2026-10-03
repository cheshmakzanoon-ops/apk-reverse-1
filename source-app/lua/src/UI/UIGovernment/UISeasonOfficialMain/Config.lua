local UISeasonOfficialMain = {
  Name = UIWindowNames.UISeasonOfficialMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialMain.UISeasonOfficialMainCtrl"),
  View = require("UI.UIGovernment.UISeasonOfficialMain.UISeasonOfficialMainView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialMain.prefab",
  HideBack = true
}
return {UISeasonOfficialMain = UISeasonOfficialMain}
