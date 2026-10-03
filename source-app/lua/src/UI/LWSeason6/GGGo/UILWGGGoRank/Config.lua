local UILWGGGoRank = {
  Name = UIWindowNames.UILWGGGoRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.GGGo.UILWGGGoRank.Controller.UILWGGGoRankCtrl"),
  View = require("UI.LWSeason6.GGGo.UILWGGGoRank.View.UILWGGGoRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/GGGo/UILWGGGoRank.prefab",
  HideBack = true
}
return {LWUISheepRank = UILWGGGoRank}
