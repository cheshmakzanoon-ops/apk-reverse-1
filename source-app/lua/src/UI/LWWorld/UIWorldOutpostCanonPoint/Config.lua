local UIWorldOutpostCanonPoint = {
  Name = UIWindowNames.UIWorldOutpostCanonPoint,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWWorld.UIWorldOutpostCanonPoint.Controller.UIWorldOutpostCanonPointCtrl"),
  View = require("UI.LWWorld.UIWorldOutpostCanonPoint.View.UIWorldOutpostCanonPointView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/World/UIWorldOutpostCanonPoint.prefab"
}
return {UIWorldOutpostCanonPoint = UIWorldOutpostCanonPoint}
