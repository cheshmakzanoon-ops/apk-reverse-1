local GoldTreePrayShow = {
  Name = UIWindowNames.GoldTreePrayShow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonGoldTree.GoldTreePrayShow.GoldTreePrayShowCtrl"),
  View = require("UI.LWSeason.LWSeasonGoldTree.GoldTreePrayShow.GoldTreePrayShowView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/GoldTree/GoldTreePrayShow.prefab"
}
return {GoldTreePrayShow = GoldTreePrayShow}
