local UILWExpiredItemExchange = {
  Name = UIWindowNames.UILWExpiredItemExchange,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWExpiredItemExchange.Control.UILWExpiredItemExchangeCtrl"),
  View = require("UI.UILWExpiredItemExchange.View.UILWExpiredItemExchangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWBag/UILWExpiredItemExchange.prefab"
}
return {UILWExpiredItemExchange = UILWExpiredItemExchange}
