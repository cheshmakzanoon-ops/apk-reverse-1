local UIHammerExchange = {
  Name = UIWindowNames.UIHammerExchange,
  Layer = UILayer.Normal,
  Ctrl = require("UI.HammerExchange.Ctrl.UIHammerExchangeCtrl"),
  View = require("UI.HammerExchange.View.UIHammerExchangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/HammerExchange/UIHammerExchange.prefab"
}
return {UIHammerExchange = UIHammerExchange}
