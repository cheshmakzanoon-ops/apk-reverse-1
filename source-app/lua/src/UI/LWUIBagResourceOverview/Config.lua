local LWUIBagResourceOverview = {
  Name = UIWindowNames.LWUIBagResourceOverview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIBagResourceOverview.Controller.LWUIBagResourceOverviewCtrl"),
  View = require("UI.LWUIBagResourceOverview.View.LWUIBagResourceOverviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWBag/LWUIBagResourceOverviewPanel.prefab"
}
return {LWUIBagResourceOverview = LWUIBagResourceOverview}
