local UIHeroMedalExchange = {
  Name = UIWindowNames.UIHeroMedalExchange,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroMedalExchange.Controller.UIHeroMedalExchangeCtrl"),
  View = require("UI.UIHero2.UIHeroMedalExchange.View.UIHeroMedalExchangeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroMedalExchange.prefab"
}
return {UIHeroMedalExchange = UIHeroMedalExchange}
