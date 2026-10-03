local HeroExchange = {
  Name = UIWindowNames.HeroExchangeGuide,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIHeroExchangeGuide.Ctrl.UIHeroExchangeGuideCtrl"),
  View = require("UI.LWUIHeroExchangeGuide.View.UIHeroExchangeGuideView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/HeroLevelAndStarReplace/UILWHeroExchangeHeroGuide.prefab"
}
return {HeroExchange = HeroExchange}
