local UIHeroInfo = {
  Name = UIWindowNames.UIHeroInfo,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHero2.UIHeroInfo.Controller.UIHeroInfoCtrl"),
  View = require("UI.UIHero2.UIHeroInfo.View.UIHeroInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroInfo.prefab"
}
return {UIHeroInfo = UIHeroInfo}
