local UIHeroFragmentExchangePanel = {
  Name = UIWindowNames.UIHeroFragmentExchangePanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroFragmentExchangePanel.Controller.UIHeroFragmentExchangePanelCtrl"),
  View = require("UI.UILWHero.UIHeroFragmentExchangePanel.View.UIHeroFragmentExchangePanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroFragmentExchangePanel.prefab"
}
return {UIHeroFragmentExchangePanel = UIHeroFragmentExchangePanel}
