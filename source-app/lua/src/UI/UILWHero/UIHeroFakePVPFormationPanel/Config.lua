local UIHeroFakePVPFormationPanel = {
  Name = UIWindowNames.UIHeroFakePVPFormation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroFakePVPFormationPanel.Controller.UIHeroFakePVPFormationPanelCtrl"),
  View = require("UI.UILWHero.UIHeroFakePVPFormationPanel.View.UIHeroFakePVPFormationPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroFakePVPFormationPanel.prefab"
}
return {UIHeroFakePVPFormationPanel = UIHeroFakePVPFormationPanel}
