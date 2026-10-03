local UIHeroPVPFormationPanel = {
  Name = UIWindowNames.UIHeroPVPFormation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroPVPFormationPanel.Controller.UIHeroPVPFormationPanelCtrl"),
  View = require("UI.UILWHero.UIHeroPVPFormationPanel.View.UIHeroPVPFormationPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroPVPFormationPanel.prefab",
  CustomKeyCodeEscape = true,
  HideBack = true
}
return {UIHeroPVPFormationPanel = UIHeroPVPFormationPanel}
