local UIFishRank = {
  Name = UIWindowNames.UIFishRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFishing.UIFishRank.UIFishRankCtrl"),
  View = require("UI.UIFishing.UIFishRank.UIFishRankView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/UIFishRank.prefab"
}
return {UIFishRank = UIFishRank}
