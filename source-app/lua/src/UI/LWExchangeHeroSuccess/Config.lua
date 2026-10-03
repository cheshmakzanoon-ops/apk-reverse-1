local ExchangeHeroSuccess = {
  Name = UIWindowNames.ExchangeHeroSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWExchangeHeroSuccess.Ctrl.ExchangeHeroSuccessCtrl"),
  View = require("UI.LWExchangeHeroSuccess.View.ExchangeHeroSuccessView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/HeroLevelAndStarReplace/ExchangeHeroSuccess.prefab"
}
return {ExchangeHeroSuccess = ExchangeHeroSuccess}
