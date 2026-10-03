local UIWorldActRadarTreasurePoint = {
  Name = UIWindowNames.UIWorldActRadarTreasurePoint,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.UIWorldActRadarTreasurePoint.Controller.UIWorldActRadarTreasurePointCtrl"),
  View = require("UI.UIActMonopoly.UIWorldActRadarTreasurePoint.View.UIWorldActRadarTreasurePointView"),
  PrefabPath = "Assets/Main/Prefabs/UI/World/UIWorldActRadarTreasurePoint.prefab"
}
return {UIWorldActRadarTreasurePoint = UIWorldActRadarTreasurePoint}
