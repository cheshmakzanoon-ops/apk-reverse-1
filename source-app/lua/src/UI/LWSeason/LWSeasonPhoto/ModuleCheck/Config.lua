local ModuleCheck = {
  Name = UIWindowNames.ModuleCheck,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonPhoto.ModuleCheck.ModuleCheckCtrl"),
  View = require("UI.LWSeason.LWSeasonPhoto.ModuleCheck.ModuleCheckView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/SeasonPhoto/ModuleCheck.prefab"
}
return {ModuleCheck = ModuleCheck}
