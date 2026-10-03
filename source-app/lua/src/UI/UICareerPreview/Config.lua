local UICareerPreview = {
  Name = UIWindowNames.UICareerPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICareerPreview.Controller.UICareerPreviewCtrl"),
  View = require("UI.UICareerPreview.View.UICareerPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIPlayerLevel/UICareerPreview.prefab"
}
return {UICareerPreview = UICareerPreview}
