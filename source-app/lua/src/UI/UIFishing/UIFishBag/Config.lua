local UIFishBag = {
  Name = UIWindowNames.UIFishBag,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFishing.UIFishBag.UIFishBagCtrl"),
  View = require("UI.UIFishing.UIFishBag.UIFishBagView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/UIFishBag.prefab",
  HideBack = true
}
return {UIFishBag = UIFishBag}
