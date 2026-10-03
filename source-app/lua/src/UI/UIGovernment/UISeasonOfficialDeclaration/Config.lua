local UISeasonOfficialDeclaration = {
  Name = UIWindowNames.UISeasonOfficialDeclaration,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialDeclaration.UISeasonOfficialDeclarationCtrl"),
  View = require("UI.UIGovernment.UISeasonOfficialDeclaration.UISeasonOfficialDeclarationView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialDeclaration.prefab"
}
return {UISeasonOfficialDeclaration = UISeasonOfficialDeclaration}
