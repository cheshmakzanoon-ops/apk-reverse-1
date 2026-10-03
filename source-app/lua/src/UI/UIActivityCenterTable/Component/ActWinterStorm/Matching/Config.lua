local UIWinterStormMatching = {
  Name = UIWindowNames.UIWinterStormMatching,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActWinterStorm.Matching.Controller.UIWinterStormMatchingCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActWinterStorm.Matching.View.UIWinterStormMatchingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/WinterStorm/UIWinterStormMatchingPanel.prefab",
  CustomKeyCodeEscape = true
}
return {UIWinterStormMatching = UIWinterStormMatching}
