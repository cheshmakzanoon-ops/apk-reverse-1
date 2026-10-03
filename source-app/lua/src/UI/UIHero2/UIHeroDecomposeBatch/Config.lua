local UIHeroDecomposeBatch = {
  Name = UIWindowNames.UIHeroDecomposeBatch,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHero2.UIHeroDecomposeBatch.Controller.UIHeroDecomposeBatchCtrl"),
  View = require("UI.UIHero2.UIHeroDecomposeBatch.View.UIHeroDecomposeBatchView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroDecomposeBatch.prefab"
}
return {UIHeroDecomposeBatch = UIHeroDecomposeBatch}
