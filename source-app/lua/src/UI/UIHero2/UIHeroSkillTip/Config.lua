local UIHeroSkillTip = {
  Name = UIWindowNames.UIHeroSkillTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroSkillTip.Controller.UIHeroSkillTipCtrl"),
  View = require("UI.UIHero2.UIHeroSkillTip.View.UIHeroSkillTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroSkillTip.prefab"
}
return {UIHeroSkillTip = UIHeroSkillTip}
