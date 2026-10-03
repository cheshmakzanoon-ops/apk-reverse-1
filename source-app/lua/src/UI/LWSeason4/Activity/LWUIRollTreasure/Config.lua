local LWUIRollTreasure = {
  Name = UIWindowNames.LWUIRollTreasure,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.Activity.LWUIRollTreasure.Controller.LWUIRollTreasureCtrl"),
  View = require("UI.LWSeason4.Activity.LWUIRollTreasure.View.LWUIRollTreasureView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Activity/RollTreasure/LWUIRollTreasure.prefab",
  HideBack = true
}
return {LWUIRollTreasure = LWUIRollTreasure}
