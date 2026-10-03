local UIStageFeatureHelpResult = {
  Name = UIWindowNames.UIStageFeatureHelpResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIStageFeatureHelpResult.Ctrl.UIStageFeatureHelpResultCtrl"),
  View = require("UI.UIStageFeatureHelpResult.View.UIStageFeatureHelpResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIStageFeatureChapter/UIStageFeatureHelpResult.prefab"
}
return {UIStageFeatureHelpResult = UIStageFeatureHelpResult}
