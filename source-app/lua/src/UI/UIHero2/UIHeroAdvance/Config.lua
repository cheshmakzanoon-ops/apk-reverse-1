local UIHeroAdvance = {
  Name = UIWindowNames.UIHeroAdvance,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHero2.UIHeroAdvance.Controller.UIHeroAdvanceCtrl"),
  View = require("UI.UIHero2.UIHeroAdvance.View.UIHeroAdvanceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroAdvance.prefab"
}
return {UIHeroAdvance = UIHeroAdvance}
