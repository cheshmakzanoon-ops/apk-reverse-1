local UIHeroBeyond = {
  Name = UIWindowNames.UIHeroBeyond,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroBeyond.Controller.UIHeroBeyondCtrl"),
  View = require("UI.UIHero2.UIHeroBeyond.View.UIHeroBeyond"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroBeyond.prefab"
}
return {UIHeroBeyond = UIHeroBeyond}
