local UIHeroUniqueWeaponPreview = {
  Name = UIWindowNames.UIHeroUniqueWeaponPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWHero.UIHeroUniqueWeaponPreview.Controller.UIHeroUniqueWeaponPreviewCtrl"),
  View = require("UI/UILWHero/UIHeroUniqueWeaponPreview/View/HeroUniqueWeaponPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/LWHero/UniqueWeapon/HeroUniqueWeaponPreveiw.prefab",
  HideBack = true
}
return {UIHeroUniqueWeaponPreview = UIHeroUniqueWeaponPreview}
