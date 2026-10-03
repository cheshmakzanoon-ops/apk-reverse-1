local Constant = {}
Constant.ImgConnection4GPath = "Assets/Main/Sprites/UI/PlayerDownloadCenter/FX_xiazaizhongxing_4G2.png"
Constant.ImgConnectionWifiPath = "Assets/Main/Sprites/UI/PlayerDownloadCenter/FX_xiazaizhongxing_wifi.png"
Constant.ManualOperateType = {
  NeverDownload = 1,
  Downloading = 2,
  Paused = 3
}
Constant.DownloadState = {
  None = -1,
  Downloading = 1,
  Paused = 2,
  Completed = 3,
  Deleting = 4
}
Constant.UIPlayerDownloadCenterMainRowItem = "Assets/Main/Prefabs/UI/PlayerDownloadCenter/UIPlayerDownloadCenterMainRowItem.prefab"
Constant.UIPlayerDownloadCenterMainTopItem = "Assets/Main/Prefabs/UI/PlayerDownloadCenter/UIPlayerDownloadCenterMainTopItem.prefab"
Constant.ProgressListItemDefaultCover = "Assets/Main/Sprites/UI/PlayerDownloadCenter/FX_xiazaizhongxing_touxiangkuang.png"
Constant.SettingKey_AutoDownload = "PlayerDownloadCenter_Setting_AutoDownload"
Constant.SettingKey_AutoClear = "PlayerDownloadCenter_Setting_AutoClear"
Constant.SettingKey_PackageManualOperateType = "PlayerDownloadCenter_PackageManualOperateType"
Constant.PlayerDownloadCenter_ShowTrulyDownloadProgress = "PlayerDownloadCenter_ShowTrulyDownloadProgress"
return Constant
