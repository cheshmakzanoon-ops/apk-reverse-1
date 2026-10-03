local UIShowFakeNewHero = {
  Name = UIWindowNames.UIShowFakeNewHero,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIShowFakeNewHero.Controller.UIShowFakeNewHeroCtrl"),
  View = require("UI.UIShowFakeNewHero.View.UIShowFakeNewHeroView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIShowFakeNewHero.prefab"
}
return {UIShowFakeNewHero = UIShowFakeNewHero}
