local UISandWormRank = {
  Name = UIWindowNames.UISandWormRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISandWormHunt.UISandWormRank.Controller.UISandWormRankCtrl"),
  View = require("UI.UISandWormHunt.UISandWormRank.View.UISandWormRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/UISandWormHunt/UISandWormRank.prefab"
}
return {UISandWormRank = UISandWormRank}
