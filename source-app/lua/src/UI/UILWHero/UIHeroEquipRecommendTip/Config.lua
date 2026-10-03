local UIHeroEquipRecommendTip = {
  Name = UIWindowNames.UIHeroEquipRecommendTip,
  Layer = UILayer.Info,
  Ctrl = require("UI/UILWHero/UIHeroEquipRecommendTip/Controller/UIHeroEquipRecommendTipCtrl"),
  View = require("UI/UILWHero/UIHeroEquipRecommendTip/View/UIHeroEquipRecommendTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroEquipRecommendTip.prefab"
}
return {UIHeroEquipRecommendTip = UIHeroEquipRecommendTip}
