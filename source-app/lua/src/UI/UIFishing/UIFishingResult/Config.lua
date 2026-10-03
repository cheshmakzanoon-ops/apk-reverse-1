local UIFishingResult = {
  Name = UIWindowNames.UIFishingResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFishing.UIFishingResult.UIFishingResultCtrl"),
  View = require("UI.UIFishing.UIFishingResult.UIFishingResultView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Fishing/UIFishingResult.prefab"
}
return {UIFishingResult = UIFishingResult}
