local UIActivityOverview = {
  Name = UIWindowNames.UIActivityOverview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityOverview.Controller.UIActivityOverviewCtrl"),
  View = require("UI.UIActivityOverview.View.UIActivityOverviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIActivityOverview/UIActivityOverview.prefab"
}
return {UIActivityOverview = UIActivityOverview}
