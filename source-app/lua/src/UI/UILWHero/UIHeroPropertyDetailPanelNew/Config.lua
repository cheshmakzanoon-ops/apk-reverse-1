local UIHeroPropertyDetailPanelNew = {
  Name = UIWindowNames.UIHeroPropertyDetailPanelNew,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UILWHero/UIHeroPropertyDetailPanelNew/Controller/UIHeroPropertyDetailPanelNewCtrl"),
  View = require("UI/UILWHero/UIHeroPropertyDetailPanelNew/View/UIHeroPropertyDetailPanelNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroPropertyDetailPanelNew.prefab"
}
return {UIHeroPropertyDetailPanelNew = UIHeroPropertyDetailPanelNew}
