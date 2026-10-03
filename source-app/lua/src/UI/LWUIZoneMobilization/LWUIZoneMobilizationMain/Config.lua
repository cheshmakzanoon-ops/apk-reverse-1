local LWUIZoneMobilizationMain = {
  Name = UIWindowNames.LWUIZoneMobilizationMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIZoneMobilization.LWUIZoneMobilizationMain.Controller.LWUIZoneMobilizationMainCtrl"),
  View = require("UI.LWUIZoneMobilization.LWUIZoneMobilizationMain.View.LWUIZoneMobilizationMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIZoneMobilization/LWUIZoneMobilizationMainPanel.prefab",
  HideBack = true
}
return {LWUIZoneMobilizationMain = LWUIZoneMobilizationMain}
