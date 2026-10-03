local UIDigTreasure = {
  Name = UIWindowNames.UIDigTreasure,
  Layer = UILayer.Normal,
  Ctrl = require("UI.DigTreasure.Ctrl.UIDigTreasureCtrl"),
  View = require("UI.DigTreasure.View.UIDigTreasureView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DigTreasure/UIDigTreasure.prefab"
}
return {UIDigTreasure = UIDigTreasure}
