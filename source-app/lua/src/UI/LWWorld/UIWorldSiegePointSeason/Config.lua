local UIWorldSiegePointSeason = {
  Name = UIWindowNames.UIWorldSiegePointSeason,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWWorld.UIWorldSiegePointSeason.Controller.UIWorldSiegePointCtrl"),
  View = require("UI.LWWorld.UIWorldSiegePointSeason.View.UIWorldSiegePointView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWWorld/UIWorldSiegePointSeason.prefab"
}
return {UIWorldSiegePointSeason = UIWorldSiegePointSeason}
