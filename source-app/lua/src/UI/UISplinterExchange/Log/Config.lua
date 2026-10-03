local UISplinterExchangeLog = {
  Name = UIWindowNames.UISplinterExchangeLog,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISplinterExchange.Log.Controller.UISplinterExchangeLogCtrl"),
  View = require("UI.UISplinterExchange.Log.View.UISplinterExchangeLogView"),
  PrefabPath = "Assets/Main/Prefabs/UI/SplinterExchange/UISplinterExchangeLog.prefab"
}
return {UISplinterExchangeLog = UISplinterExchangeLog}
