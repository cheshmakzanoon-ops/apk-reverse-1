local UIHeroUnlockNewSkillPanel = {
  Name = UIWindowNames.UIHeroUnlockNewSkillPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIHeroUnlockNewSkillPanel.Controller.UIHeroUnlockNewSkillPanelCtrl"),
  View = require("UI.UIHeroUnlockNewSkillPanel.View.UIHeroUnlockNewSkillPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroUnlockNewSkillPanel.prefab"
}
return {UIHeroUnlockNewSkillPanel = UIHeroUnlockNewSkillPanel}
