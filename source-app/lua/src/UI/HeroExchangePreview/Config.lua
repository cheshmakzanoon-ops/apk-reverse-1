local HeroExchangePreview = {
  Name = UIWindowNames.HeroExchangePreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.HeroExchangePreview.Ctrl.HeroExchangePreviewCtrl"),
  View = require("UI.HeroExchangePreview.View.HeroExchangePreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/HeroLevelAndStarReplace/HeroExchangePreview.prefab"
}
return {HeroExchangePreview = HeroExchangePreview}
