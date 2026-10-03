local UIHeroWeaponSkillTip = {
  Name = UIWindowNames.UIHeroWeaponSkillTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroWeaponSkillTip.Controller.UIHeroWeaponSkillTipCtrl"),
  View = require("UI.UILWHero.UIHeroWeaponSkillTip.View.UIHeroWeaponSkillTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroWeaponSkillTip.prefab"
}
return {UIHeroWeaponSkillTip = UIHeroWeaponSkillTip}
