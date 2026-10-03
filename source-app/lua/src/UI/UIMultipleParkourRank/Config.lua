local UIMultipleParkourRank = {
  Name = UIWindowNames.UIMultipleParkourRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMultipleParkourRank.Controller.UIMultipleParkourRankCtrl"),
  View = require("UI.UIMultipleParkourRank.View.UIMultipleParkourRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/MultipleParkour/UIMultipleParkourRankView.prefab"
}
return {UIMultipleParkourRank = UIMultipleParkourRank}
