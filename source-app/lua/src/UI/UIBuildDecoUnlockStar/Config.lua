local UIBuildDecoUnlockStar = {
  Name = UIWindowNames.UIBuildDecoUnlockStar,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBuildDecoUnlockStar.Ctrl.UIDecoUnlockStarCtrl"),
  View = require("UI.UIBuildDecoUnlockStar.View.UIDecoUnlockStarView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildUpgrade/UIDecoUnlockStar.prefab"
}
return {UIBuildDecoUnlockStar = UIBuildDecoUnlockStar}
