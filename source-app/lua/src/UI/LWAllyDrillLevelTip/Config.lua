local LWAllyDrillLevelTip = {
  Name = UIWindowNames.LWAllyDrillLevelTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWAllyDrillLevelTip.Controller.LWAllyDrillLevelTipCtrl"),
  View = require("UI.LWAllyDrillLevelTip.View.LWAllyDrillLevelTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWAllyDrillLevelTip/LWAllyDrillLevelTip.prefab"
}
return {LWAllyDrillLevelTip = LWAllyDrillLevelTip}
