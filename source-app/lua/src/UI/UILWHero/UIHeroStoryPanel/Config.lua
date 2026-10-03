local UIHeroStoryPanel = {
  Name = UIWindowNames.UIHeroStoryPanel,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroStoryPanel.Controller.UIHeroStoryPanelCtrl"),
  View = require("UI.UILWHero.UIHeroStoryPanel.View.UIHeroStoryPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UIHeroStoryPanel.prefab"
}
return {UIHeroStoryPanel = UIHeroStoryPanel}
