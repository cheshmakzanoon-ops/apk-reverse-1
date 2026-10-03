local UILWVisibilitySettings = {
  Name = UIWindowNames.UILWVisibilitySettings,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPlayerInfo.UILWVisibilitySettings.Ctrl.UILWVisibilitySettingsCtrl"),
  View = require("UI.LWPlayerInfo.UILWVisibilitySettings.View.UILWVisibilitySettingsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/FiendCircle/PostVisibilitySettings.prefab"
}
return {UILWVisibilitySettings = UILWVisibilitySettings}
