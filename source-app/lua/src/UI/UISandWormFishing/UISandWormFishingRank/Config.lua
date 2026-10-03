local UISandWormFishingRank = {
  Name = UIWindowNames.UISandWormFishingRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISandWormFishing.UISandWormFishingRank.Controller.UISandWormFishingRankCtrl"),
  View = require("UI.UISandWormFishing.UISandWormFishingRank.View.UISandWormFishingRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/UISandWormFishing/UISandWormFishingRank.prefab",
  HideBack = true
}
return {UISandWormFishingRank = UISandWormFishingRank}
