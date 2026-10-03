local UIScratchSelectHero = {
  Name = UIWindowNames.UIScratchSelectHero,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIScratchSelectHero.Ctrl.UIScratchSelectHeroCtrl"),
  View = require("UI.UIScratchSelectHero.View.UIScratchSelectHeroView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIScratchSelectHero/UIScratchSelectHero.prefab"
}
return {UIScratchSelectHero = UIScratchSelectHero}
