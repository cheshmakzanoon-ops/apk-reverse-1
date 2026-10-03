local UIHeroExhibit = {
  Name = UIWindowNames.UIHeroExhibitPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroExhibitPanel.Controller.UIHeroExhibitPanelCtrl"),
  View = require("UI.UILWHero.UIHeroExhibitPanel.View.UIHeroExhibitPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroExhibitPanel.prefab",
  CustomKeyCodeEscape = true
}
return {UIHeroExhibit = UIHeroExhibit}
