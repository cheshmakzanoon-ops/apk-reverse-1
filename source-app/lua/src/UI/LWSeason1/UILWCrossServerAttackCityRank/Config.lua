local UILWCrossServerAttackCityRank = {
  Name = UIWindowNames.UILWCrossServerAttackCityRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason1.UILWCrossServerAttackCityRank.Controller.UILWCrossServerAttackCityRankCtrl"),
  View = require("UI.LWSeason1.UILWCrossServerAttackCityRank.View.UILWCrossServerAttackCityRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/CrossServerAttackCity/CrossServerAttackCityRank.prefab"
}
return {UILWCrossServerAttackCityRank = UILWCrossServerAttackCityRank}
