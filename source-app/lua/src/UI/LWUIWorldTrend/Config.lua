local LWUIWorldTrend = {
  Name = UIWindowNames.LWUIWorldTrend,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIWorldTrend.Controller.LWUIWorldTrendCtrl"),
  View = require("UI.LWUIWorldTrend.View.LWUIWorldTrendView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIWorldTrend/LWUIWorldTrendView.prefab",
  HideBack = true
}
return {LWUIWorldTrend = LWUIWorldTrend}
