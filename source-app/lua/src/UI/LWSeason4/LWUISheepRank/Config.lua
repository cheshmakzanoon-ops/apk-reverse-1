local LWUISheepRank = {
  Name = UIWindowNames.LWUISheepRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.LWUISheepRank.Controller.LWUISheepRankCtrl"),
  View = require("UI.LWSeason4.LWUISheepRank.View.LWUISheepRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/LWSheep/LWUISheepRank.prefab",
  HideBack = true
}
return {LWUISheepRank = LWUISheepRank}
