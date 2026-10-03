local UIDecorationPreview = {
  Name = UIWindowNames.UIDecorationPreview,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIDecoration.UIDecorationPreview.Controller.UIDecorationPreviewCtrl"),
  View = require("UI.UIDecoration.UIDecorationPreview.View.UIDecorationPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIDecoration/UIDecorationPreview.prefab"
}
return {UIDecorationPreview = UIDecorationPreview}
