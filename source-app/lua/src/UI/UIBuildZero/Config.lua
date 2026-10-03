local UIBuildZero = {
  Name = UIWindowNames.UIBuildZero,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIBuildZero.Controller.UIBuildZeroCtrl"),
  View = require("UI.UIBuildZero.View.UIBuildZeroView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/UIBuildZero.prefab"
}
return {UIBuildZero = UIBuildZero}
