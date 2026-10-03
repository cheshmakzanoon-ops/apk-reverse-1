local UIBuildDecoratePropPreview = {
  Name = UIWindowNames.UIBuildDecoratePropPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDecoUpgradePropPreview.Ctrl.UIBuildDecoratePropPreviewCtrl"),
  View = require("UI.UIDecoUpgradePropPreview.View.UIBuildDecoratePropPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/UIBuildDecoratePropPreviewView.prefab"
}
return {UIBuildDecoratePropPreview = UIBuildDecoratePropPreview}
