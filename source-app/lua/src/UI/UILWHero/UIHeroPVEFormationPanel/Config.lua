local UIHeroPVEFormationPanel = {
  Name = UIWindowNames.UIHeroPVEFormation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroPVEFormationPanel.Controller.UIHeroPVEFormationPanelCtrl"),
  View = require("UI.UILWHero.UIHeroPVEFormationPanel.View.UIHeroPVEFormationPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroPVEFormationPanel.prefab"
}
return {UIHeroPVEFormationPanel = UIHeroPVEFormationPanel}
