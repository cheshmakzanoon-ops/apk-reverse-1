local UIPlayerDownloadCenterSetting = {
  Name = UIWindowNames.UIPlayerDownloadCenterSetting,
  Layer = UILayer.Normal,
  Ctrl = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterSetting.Ctrl.UIPlayerDownloadCenterSettingCtrl"),
  View = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterSetting.View.UIPlayerDownloadCenterSettingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/PlayerDownloadCenter/UIPlayerDownloadCenterSetting.prefab"
}
return {UIPlayerDownloadCenterSetting = UIPlayerDownloadCenterSetting}
