local UIScienceTabLock = {
  Name = UIWindowNames.UIScienceTabLock,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIScienceTabLock.Controller.UIScienceTabLockCtrl"),
  View = require("UI.UIScienceTabLock.View.UIScienceTabLockView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIScience/UIScienceTabLock.prefab"
}
return {UIScienceTabLock = UIScienceTabLock}
