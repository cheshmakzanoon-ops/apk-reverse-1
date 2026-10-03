local UIFlowerCarRank = {
  Name = UIWindowNames.UIFlowerCarRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFlowerCarRank.Controller.UIFlowerCarRankCtrl"),
  View = require("UI.UIFlowerCarRank.View.UIFlowerCarRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/World/UIFlowerCarRank.prefab"
}
return {UIFlowerCarRank = UIFlowerCarRank}
