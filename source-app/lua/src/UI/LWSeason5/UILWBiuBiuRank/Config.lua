local UILWBiuBiuRank = {
  Name = UIWindowNames.UILWBiuBiuRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.UILWBiuBiuRank.Controller.UILWBiuBiuRankCtrl"),
  View = require("UI.LWSeason5.UILWBiuBiuRank.View.UILWBiuBiuRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/BiuBiu/UILWBiuBiuRank.prefab",
  HideBack = true
}
return {LWUISheepRank = UILWBiuBiuRank}
