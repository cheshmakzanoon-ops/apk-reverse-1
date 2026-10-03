local UIFishingMain = {
  Name = UIWindowNames.UIFishingMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFishing.UIFishingMain.UIFishingMainCtrl"),
  View = require("UI.UIFishing.UIFishingMain.UIFishingMainView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/UIFishingMain.prefab",
  HideBack = true
}
return {UIFishingMain = UIFishingMain}
