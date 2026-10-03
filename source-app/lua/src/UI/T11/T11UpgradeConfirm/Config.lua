local T11UpgradeConfirm = {
  Name = UIWindowNames.T11UpgradeConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.T11.T11UpgradeConfirm.Ctrl.T11UpgradeConfirmCtrl"),
  View = require("UI.T11.T11UpgradeConfirm.View.T11UpgradeConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/T11/T11UpgradeConfirm/T11UpgradeConfirm.prefab"
}
return {T11UpgradeConfirm = T11UpgradeConfirm}
