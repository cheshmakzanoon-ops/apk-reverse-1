local UIHeroPropertyDetailPanel = {
  Name = UIWindowNames.UIHeroPropertyDetailPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroPropertyDetailPanel.Controller.UIHeroPropertyDetailPanelCtrl"),
  View = require("UI.UILWHero.UIHeroPropertyDetailPanel.View.UIHeroPropertyDetailPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroPropertyDetailPanel.prefab"
}
return {UIHeroPropertyDetailPanel = UIHeroPropertyDetailPanel}
