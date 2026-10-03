local UIHeroSpecialTip = {
  Name = UIWindowNames.UIHeroSimpleTip,
  Layer = UILayer.Info,
  Ctrl = require("UI.UILWHero.UIHeroSimpleTip.Controller.UIHeroSimpleTipCtrl"),
  View = require("UI.UILWHero.UIHeroSimpleTip.View.UIHeroSimpleTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroSimpleTip.prefab"
}
return {UIHeroSpecialTip = UIHeroSpecialTip}
