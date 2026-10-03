local HeroAwakenSkillPreview = {
  Name = UIWindowNames.HeroAwakenSkillPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroAwakenSkillPreview.Ctrl.HeroAwakenSkillPreviewCtrl"),
  View = require("UI.UILWHero.UIHeroAwakenSkillPreview.View.HeroAwakenSkillPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/HeroAwakenSkillPreview.prefab",
  HideBack = true
}
return {HeroAwakenSkillPreview = HeroAwakenSkillPreview}
