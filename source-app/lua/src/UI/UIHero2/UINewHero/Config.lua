local UINewHero = {
  Name = UIWindowNames.UINewHero,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UINewHero.Controller.UINewHeroCtrl"),
  View = require("UI.UIHero2.UINewHero.View.UINewHero"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UINewHero.prefab"
}
return {UINewHero = UINewHero}
