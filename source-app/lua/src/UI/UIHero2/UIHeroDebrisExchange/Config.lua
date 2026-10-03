local UIHeroDebrisExchange = {
  Name = UIWindowNames.UIHeroDebrisExchange,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHero2.UIHeroDebrisExchange.Controller.UIHeroDebrisExchangeCtrl"),
  View = require("UI.UIHero2.UIHeroDebrisExchange.View.UIHeroDebrisExchangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroDebrisExchange.prefab"
}
return {UIHeroDebrisExchange = UIHeroDebrisExchange}
