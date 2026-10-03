local UIHeroSpecialTip = {
  Name = UIWindowNames.UIHeroSpecialTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroSpecialTip.Controller.UIHeroSpecialTipCtrl"),
  View = require("UI.UILWHero.UIHeroSpecialTip.View.UIHeroSpecialTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroSpecialTip.prefab"
}
return {UIHeroSpecialTip = UIHeroSpecialTip}
