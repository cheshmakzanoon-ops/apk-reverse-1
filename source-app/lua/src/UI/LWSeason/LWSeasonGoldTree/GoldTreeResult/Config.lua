local GoldTreeResult = {
  Name = UIWindowNames.GoldTreeResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonGoldTree.GoldTreeResult.GoldTreeResultCtrl"),
  View = require("UI.LWSeason.LWSeasonGoldTree.GoldTreeResult.GoldTreeResultView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/GoldTree/GoldTreeResult.prefab"
}
return {GoldTreeResult = GoldTreeResult}
