local LWNewGuideHeroView = {
  Name = UIWindowNames.LWNewGuideHeroView,
  Layer = UILayer.Guide,
  Ctrl = require("UI.LWNewGuideHero.Ctrl.UIHeroGuideTipsNewCtrl"),
  View = require("UI.LWNewGuideHero.View.UIHeroGuideTipsNewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWGuideHeroNew/UIHeroGuideTipsNew.prefab"
}
return {LWNewGuideHeroView = LWNewGuideHeroView}
