local UIHeroSkillUpgradeSuccess = {
  Name = UIWindowNames.UIHeroSkillUpgradeSuccess,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHero2.UIHeroSkillUpgradeSuccess.Controller.UIHeroSkillUpgradeSuccessCtrl"),
  View = require("UI.UIHero2.UIHeroSkillUpgradeSuccess.View.UIHeroSkillUpgradeSuccess"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroSkillUpgradeSuccess.prefab"
}
return {UIHeroSkillUpgradeSuccess = UIHeroSkillUpgradeSuccess}
