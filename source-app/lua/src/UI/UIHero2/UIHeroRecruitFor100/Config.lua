local UIHero100Recruit = {
  Name = UIWindowNames.UIHero100Recruit,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroRecruitFor100.Controller.UIHero100RecruitCtrl"),
  View = require("UI.UIHero2.UIHeroRecruitFor100.View.UIHero100RecruitView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHero100RecruitReward.prefab",
  HideBack = true
}
return {UIHero100Recruit = UIHero100Recruit}
