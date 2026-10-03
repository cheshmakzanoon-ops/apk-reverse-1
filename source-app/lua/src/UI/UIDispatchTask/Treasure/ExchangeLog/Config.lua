local UIDispathTreasureExchangeLog = {
  Name = UIWindowNames.UIDispathTreasureExchangeLog,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Treasure.ExchangeLog.Controller.UIDispathTreasureExchangeLogCtrl"),
  View = require("UI.UIDispatchTask.Treasure.ExchangeLog.View.UIDispathTreasureExchangeLogView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DispatchTreasure/UIDispathTreasureExchangeLog.prefab"
}
return {UIDispathTreasureExchangeLog = UIDispathTreasureExchangeLog}
