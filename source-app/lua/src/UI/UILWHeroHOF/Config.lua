local UILWHeroHOF = {
  Name = UIWindowNames.UILWHeroHOF,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHeroHOF.Controller.UILWHeroHOFPanelCtrl"),
  View = require("UI.UILWHeroHOF.View.UILWHeroHOFPanelView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UILWHeroHOFPanel.prefab",
  HideBack = true
}
return {UILWHeroHOF = UILWHeroHOF}
