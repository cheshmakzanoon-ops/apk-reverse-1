local LWUIStageFeatureChapter = {
  Name = UIWindowNames.LWUIStageFeatureChapter,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIStageFeatureChapter.Controller.LWUIStageFeatureChapterCtrl"),
  View = require("UI.LWUIStageFeatureChapter.View.LWUIStageFeatureChapterView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIStageFeatureChapter/LWUIStageFeatureChapter.prefab",
  HideBack = true
}
return {LWUIStageFeatureChapter = LWUIStageFeatureChapter}
