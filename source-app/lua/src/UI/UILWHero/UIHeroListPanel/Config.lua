local UIHeroListPanel = {
  Name = UIWindowNames.UIHeroListPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroListPanel.Controller.UIHeroListPanelCtrl"),
  View = require("UI.UILWHero.UIHeroListPanel.View.UIHeroListPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroListPanel.prefab",
  HideBack = true
}
return {UIHeroListPanel = UIHeroListPanel}
