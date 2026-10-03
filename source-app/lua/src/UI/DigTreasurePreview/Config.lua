local UIDigTreasurePreview = {
  Name = UIWindowNames.UIDigTreasurePreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.DigTreasurePreview.Ctrl.UIDigTreasurePreviewCtrl"),
  View = require("UI.DigTreasurePreview.View.UIDigTreasurePreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DigTreasure/UIDigTreasurePreview.prefab"
}
return {UIDigTreasurePreview = UIDigTreasurePreview}
