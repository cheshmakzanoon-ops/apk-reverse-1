local UIHeroGroupedPropertyDetailTip = {
  Name = UIWindowNames.UIHeroGroupedPropertyDetailTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UILWHero/UIHeroGroupedPropertyDetailTip/Controller/UIHeroGroupedPropertyDetailTipCtrl"),
  View = require("UI/UILWHero/UIHeroGroupedPropertyDetailTip/View/UIHeroGroupedPropertyDetailTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroPropertyDetailTipNew.prefab"
}
return {UIHeroGroupedPropertyDetailTip = UIHeroGroupedPropertyDetailTip}
