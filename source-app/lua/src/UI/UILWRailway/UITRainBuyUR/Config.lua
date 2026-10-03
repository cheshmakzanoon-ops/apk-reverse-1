local UITRainBuyUR = {
  Name = UIWindowNames.UITrainBuyUR,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITRainBuyUR.Controller.UITRainBuyURCtrl"),
  View = require("UI.UILWRailway.UITRainBuyUR.View.UITRainBuyURView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UITrainBuyUR.prefab"
}
return {UITRainBuyUR = UITRainBuyUR}
