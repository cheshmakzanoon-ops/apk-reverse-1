local UIWindow = {
  Name = "Background",
  Layer = UILayer.Normal,
  Ctrl = UIBaseCtrl,
  View = UIBaseView,
  PrefabPath = "",
  State = 0,
  OpenOptions = {},
  CloseTimer = nil,
  InstanceRequest = nil,
  HighFPSLockInfo = {Id = -1, DelayHandle = nil},
  HideSceneCamera = false
}
return DataClass("UIWindow", UIWindow)
