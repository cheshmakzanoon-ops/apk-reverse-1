local UIHeroRecruitTipNew = {
  Name = UIWindowNames.UIHeroRecruitTipNew,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroRecruitTipNew.Controller.UIHeroRecruitTipCtrl"),
  View = require("UI.UIHero2.UIHeroRecruitTipNew.View.UIHeroRecruitTip"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroRecruitTipNew.prefab"
}
return {UIHeroRecruitTipNew = UIHeroRecruitTipNew}
