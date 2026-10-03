local UIWorldTrend = {
  Name = UIWindowNames.UIWorldTrend,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldTrend.Controller.UIWorldTrendCtrl"),
  View = require("UI.UIWorldTrend.View.UIWorldTrendView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIWorldTrend/UIWorldTrend.prefab"
}
return {UIWorldTrend = UIWorldTrend}
