local UIDestroyerOfficialEncourage = {
  Name = UIWindowNames.UIDestroyerOfficialEncourage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UIDestroyerOfficialEncourage.UIDestroyerOfficialEncourageCtrl"),
  View = require("UI.UIGovernment.UIDestroyerOfficialEncourage.UIDestroyerOfficialEncourageView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UIDestroyerOfficialEncourage.prefab",
  HideBack = true
}
return {UIDestroyerOfficialEncourage = UIDestroyerOfficialEncourage}
