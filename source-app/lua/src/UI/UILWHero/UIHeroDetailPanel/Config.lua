local UIHeroDetail = {
  Name = UIWindowNames.UIHeroDetailPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroDetailPanel.Controller.UIHeroDetailPanelCtrl"),
  View = require("UI.UILWHero.UIHeroDetailPanel.View.UIHeroDetailPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroDetailPanel.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {UIHeroDetail = UIHeroDetail}
