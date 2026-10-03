local UIHeroRecruitTip = {
  Name = UIWindowNames.UIHeroRecruitTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroRecruitTip.Controller.UIHeroRecruitTipCtrl"),
  View = require("UI.UIHero2.UIHeroRecruitTip.View.UIHeroRecruitTip"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroRecruitTip.prefab"
}
return {UIHeroRecruitTip = UIHeroRecruitTip}
