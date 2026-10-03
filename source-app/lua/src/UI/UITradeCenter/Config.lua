local UITradeCenter = {
  Name = UIWindowNames.UITradeCenter,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UITradeCenter.Controller.UITradeCenterCtrl"),
  View = require("UI.UITradeCenter.View.UITradeCenterView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UITradingCenter/UITradeCenter.prefab"
}
return {UITradeCenter = UITradeCenter}
