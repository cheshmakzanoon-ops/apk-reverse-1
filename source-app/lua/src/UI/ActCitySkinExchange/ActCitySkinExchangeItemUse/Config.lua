local ActCitySkinExchangeItemUse = {
  Name = UIWindowNames.ActCitySkinExchangeItemUse,
  Layer = UILayer.Normal,
  Ctrl = require("UI.ActCitySkinExchange.ActCitySkinExchangeItemUse.Controller.ActCitySkinExchangeItemUseCtrl"),
  View = require("UI.ActCitySkinExchange.ActCitySkinExchangeItemUse.View.ActCitySkinExchangeItemUseView"),
  PrefabPath = "Assets/Main/ActivityFestival/ActCitySkinExchange/Prefab/ActCitySkinExchangeItemUse.prefab"
}
return {ActCitySkinExchangeItemUse = ActCitySkinExchangeItemUse}
