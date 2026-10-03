local UIWorldTrendRank = {
  Name = UIWindowNames.UIWorldTrendRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIWorldTrend.UIWorldTrendRank.Controller.UIWorldTrendRankCtrl"),
  View = require("UI.UIWorldTrend.UIWorldTrendRank.View.UIWorldTrendRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIWorldTrend/UIWorldTrendRank.prefab"
}
return {UIWorldTrendRank = UIWorldTrendRank}
