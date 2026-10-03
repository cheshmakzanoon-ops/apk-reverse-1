local AccuRechargeOverlapDisplay = {
  Name = UIWindowNames.AccuRechargeOverlapDisplay,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.UIAccuRecharge.AccuRechargeDisplay.Ctrl.AccuRechargeOverlapDisplayCtrl"),
  View = require("UI.UIActivityCenterTable.Component.UIAccuRecharge.AccuRechargeDisplay.View.AccuRechargeOverlapDisplayView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/NewYear/UIAccuRechargeOverlapDisplay.prefab"
}
return {AccuRechargeOverlapDisplay = AccuRechargeOverlapDisplay}
