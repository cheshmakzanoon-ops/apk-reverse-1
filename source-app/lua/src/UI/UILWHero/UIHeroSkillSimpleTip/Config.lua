local UIHeroSpecialTip = {
  Name = UIWindowNames.UIHeroSkillSimpleTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroSkillSimpleTip.Controller.UIHeroSkillSimpleTipCtrl"),
  View = require("UI.UILWHero.UIHeroSkillSimpleTip.View.UIHeroSkillSimpleTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroSkillSimpleTip.prefab"
}
return {UIHeroSpecialTip = UIHeroSpecialTip}
