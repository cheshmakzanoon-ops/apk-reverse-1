local UIUpgradeAllianceNotice = {
  Name = UIWindowNames.UIUpgradeAllianceNotice,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIAllianceNotice.Upgrade.Controller.UIUpgradeAllianceNoticeCtrl"),
  View = require("UI.UIAllianceNotice.Upgrade.View.UIUpgradeAllianceNoticeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/AllianceNotice/UIUpgradeAllianceNotice.prefab"
}
return {UIUpgradeAllianceNotice = UIUpgradeAllianceNotice}
