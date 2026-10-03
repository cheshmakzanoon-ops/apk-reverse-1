local UIResourceExchange = {
  Name = UIWindowNames.UIResourceExchange,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIResourceExchange.Controller.UIResourceExchangeCtrl"),
  View = require("UI.UIResourceExchange.View.UIResourceExchangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIResource/UIResourceExchange.prefab"
}
return {UIResourceExchange = UIResourceExchange}
