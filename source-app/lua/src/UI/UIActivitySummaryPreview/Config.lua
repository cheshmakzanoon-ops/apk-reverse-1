local UIActivitySummaryPreview = {
  Name = UIWindowNames.UIActivitySummaryPreview,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIActivitySummaryPreview.Controller.UIActivitySummaryPreviewCtrl"),
  View = require("UI.UIActivitySummaryPreview.View.UIActivitySummaryPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIActivitySummary/UIActivitySummaryPreview.prefab"
}
return {UIActivitySummaryPreview = UIActivitySummaryPreview}
