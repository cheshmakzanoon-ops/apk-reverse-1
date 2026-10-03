local UILWSeasonRank = {
  Name = UIWindowNames.UILWSeasonRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonRank.Controller.LWSeasonRankCtrl"),
  View = require("UI.LWSeason.LWSeasonRank.View.LWSeasonRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonRank.prefab",
  HideBack = true
}
return {UILWSeasonRank = UILWSeasonRank}
