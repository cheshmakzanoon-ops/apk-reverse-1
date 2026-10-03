local UIHeroTip = {
  Name = UIWindowNames.UIHeroTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroTip.Controller.UIHeroTipCtrl"),
  View = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroTip.prefab"
}
return {UIHeroTip = UIHeroTip}
