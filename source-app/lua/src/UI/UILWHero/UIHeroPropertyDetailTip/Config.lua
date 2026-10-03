local UIHeroPropertyDetailTip = {
  Name = UIWindowNames.UIHeroPropertyDetailTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroPropertyDetailTip.Controller.UIHeroPropertyDetailTipCtrl"),
  View = require("UI.UILWHero.UIHeroPropertyDetailTip.View.UIHeroPropertyDetailTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroPropertyDetailTip.prefab"
}
return {UIHeroPropertyDetailTip = UIHeroPropertyDetailTip}
