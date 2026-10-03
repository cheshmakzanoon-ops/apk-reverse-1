local UIHeroRecruitWishGuide = {
  Name = UIWindowNames.UIHeroRecruitWishGuide,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroRecruitWishGuide.Ctrl.UIHeroRecruitWishGuideCtrl"),
  View = require("UI.UIHero2.UIHeroRecruitWishGuide.View.UIHeroRecruitWishGuideView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroRecruitWishGuide.prefab"
}
return {UIHeroRecruitWishGuide = UIHeroRecruitWishGuide}
