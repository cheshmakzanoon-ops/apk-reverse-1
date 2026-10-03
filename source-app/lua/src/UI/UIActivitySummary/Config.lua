local UIActivitySummary = {
  Name = UIWindowNames.UIActivitySummary,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIActivitySummary.Controller.UIActivitySummaryCtrl"),
  View = require("UI.UIActivitySummary.View.UIActivitySummaryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIActivitySummary/UIActivitySummary.prefab"
}
return {UIActivitySummary = UIActivitySummary}
