local UIDetectEventLevelUp = {
  Name = UIWindowNames.UIDetectEventLevelUp,
  Layer = UILayer.Info,
  Ctrl = require("UI.UILWRadarCenter.UIDetectEventLevelUp.Controller.UIDetectEventLevelUpCtrl"),
  View = require("UI.UILWRadarCenter.UIDetectEventLevelUp.View.UIDetectEventLevelUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRadarCenter/UIDetectEventLevelUp.prefab",
  HideBack = true
}
return {UIDetectEventLevelUp = UIDetectEventLevelUp}
