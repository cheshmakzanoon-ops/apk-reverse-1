local UITrainBuy = {
  Name = UIWindowNames.UITrainBuy,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITrainBuy.Controller.UITrainBuyCtrl"),
  View = require("UI.UILWRailway.UITrainBuy.View.UITrainBuyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UITrainBuy.prefab"
}
return {UITrainBuy = UITrainBuy}
