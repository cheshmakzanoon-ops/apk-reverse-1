local UILWSeasonUpgradeLog = {
  Name = UIWindowNames.UILWSeasonUpgradeLog,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonUpgradeLog.Controller.LWSeasonUpgradeLogCtrl"),
  View = require("UI.LWSeason.LWSeasonUpgradeLog.View.LWSeasonUpgradeLogView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonUpgradeLogView.prefab"
}
return {UILWSeasonUpgradeLog = UILWSeasonUpgradeLog}
