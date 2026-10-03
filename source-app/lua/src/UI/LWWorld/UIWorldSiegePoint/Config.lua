local UIWorldSiegePoint = {
  Name = UIWindowNames.UIWorldSiegePoint,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWWorld.UIWorldSiegePoint.Controller.UIWorldSiegePointCtrl"),
  View = require("UI.LWWorld.UIWorldSiegePoint.View.UIWorldSiegePointView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWWorld/UIWorldSiegePoint.prefab"
}
return {UIWorldSiegePoint = UIWorldSiegePoint}
