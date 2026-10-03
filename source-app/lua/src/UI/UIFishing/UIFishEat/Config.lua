local UIFishEat = {
  Name = UIWindowNames.UIFishEat,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFishing.UIFishEat.UIFishEatCtrl"),
  View = require("UI.UIFishing.UIFishEat.UIFishEatView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/UIFishEat.prefab"
}
return {UIFishEat = UIFishEat}
