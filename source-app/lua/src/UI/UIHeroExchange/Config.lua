local UIHeroExchange = {
  Name = UIWindowNames.UIHeroExchange,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHeroExchange.Controller.UIHeroExchangeCtrl"),
  View = require("UI.UIHeroExchange.View.UIHeroExchangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHeroResetShop/UIHeroExchange.prefab"
}
return {UICommonShop = UIHeroExchange}
