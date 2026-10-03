local UIHeroDecompose = {
  Name = UIWindowNames.UIHeroDecompose,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHero2.UIHeroDecompose.Controller.UIHeroDecomposeCtrl"),
  View = require("UI.UIHero2.UIHeroDecompose.View.UIHeroDecomposeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroDecompose.prefab"
}
return {UIHeroDecompose = UIHeroDecompose}
