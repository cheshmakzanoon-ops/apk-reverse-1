local LWUISoldierNumTips = {
  Name = UIWindowNames.LWUISoldierNumTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWUISoldierNumTip.Controller.LWUISoldierNumTipsCtrl"),
  View = require("UI.LWUISoldierNumTip.View.LWUISoldierNumTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWCommon/UISoldierNumTips.prefab"
}
return {LWUISoldierNumTips = LWUISoldierNumTips}
