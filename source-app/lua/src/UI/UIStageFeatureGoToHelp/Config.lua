local UIStageFeatureGoToHelp = {
  Name = UIWindowNames.UIStageFeatureGoToHelp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIStageFeatureGoToHelp.Ctrl.UIStageFeatureGoToHelpCtrl"),
  View = require("UI.UIStageFeatureGoToHelp.View.UIStageFeatureGoToHelpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIStageFeatureChapter/UIStageFeatureGoToHelp.prefab"
}
return {UIStageFeatureGoToHelp = UIStageFeatureGoToHelp}
