local LWUIRadarTreasureShip = {
  Name = UIWindowNames.LWUIRadarTreasureShip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.Activity.LWUIRollTreasureShip.Controller.LWUIRollTreasureShipCtrl"),
  View = require("UI.LWSeason4.Activity.LWUIRollTreasureShip.View.LWUIRollTreasureShipView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Activity/RollTreasure/LWUIRollTreasureShip.prefab"
}
return {LWUIRadarTreasureShip = LWUIRadarTreasureShip}
