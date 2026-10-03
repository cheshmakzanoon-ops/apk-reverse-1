local UIHeroRecruitWish = {
  Name = UIWindowNames.UIHeroRecruitWish,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroRecruitWish.Ctrl.UIHeroRecruitWishCtrl"),
  View = require("UI.UIHero2.UIHeroRecruitWish.View.UIHeroRecruitWishView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroRecruitWish.prefab"
}
return {UIHeroRecruitWish = UIHeroRecruitWish}
