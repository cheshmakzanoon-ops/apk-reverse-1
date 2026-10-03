local UIAllyDrillRank = {
  Name = UIWindowNames.UIAllyDrillRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllyDrill.UIAllyDrillRank.Controller.UIAllyDrillRankCtrl"),
  View = require("UI.UIAllyDrill.UIAllyDrillRank.View.UIAllyDrillRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/AllyDrill/UIAllyDrillRank.prefab"
}
return {UIAllyDrillRank = UIAllyDrillRank}
