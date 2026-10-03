local UIHeroSkillDetailPanel = {
  Name = UIWindowNames.UIHeroSkillDetailPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroSkillDetailPanel.Controller.UIHeroSkillDetailPanelCtrl"),
  View = require("UI.UILWHero.UIHeroSkillDetailPanel.View.UIHeroSkillDetailPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroSkillDetailPanel.prefab"
}
return {UIHeroSkillDetailPanel = UIHeroSkillDetailPanel}
