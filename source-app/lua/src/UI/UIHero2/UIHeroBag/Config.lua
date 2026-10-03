local UIHeroBag = {
  Name = UIWindowNames.UIHeroBag,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHero2.UIHeroBag.Controller.UIHeroBagCtrl"),
  View = require("UI.UIHero2.UIHeroBag.View.UIHeroBagView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroBag.prefab"
}
return {UIHeroBag = UIHeroBag}
