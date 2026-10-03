local UIDetectDigTreasure = {
  Name = UIWindowNames.UIDetectDigTreasure,
  Layer = UILayer.Normal,
  Ctrl = require("UI.DigMap.Detect.Ctrl.UIDetectDigTreasureCtrl"),
  View = require("UI.DigMap.Detect.View.UIDetectDigTreasureView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DigTreasureCommon/Detect/UIDetectDigTreasure.prefab"
}
return {UIDetectDigTreasure = UIDetectDigTreasure}
