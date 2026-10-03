local HeroAwakenSkinPreview = {
  Name = UIWindowNames.HeroAwakenSkinPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroAwakenSkinPreview.Ctrl.HeroAwakenSkinPreviewCtrl"),
  View = require("UI.UILWHero.UIHeroAwakenSkinPreview.View.HeroAwakenSkinPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/HeroAwakenSkinPreview.prefab",
  HideBack = true
}
return {HeroAwakenSkinPreview = HeroAwakenSkinPreview}
