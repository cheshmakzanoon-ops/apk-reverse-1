local UIPushSettings = {
  Name = UIWindowNames.UIPushSettings,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatNew.UIPushSettings.Controller.UIPushSettingsCtrl"),
  View = require("UI.UIChatNew.UIPushSettings.View.UIPushSettingsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/UIPushSettings.prefab",
  CustomKeyCodeEscape = true
}
return {UIPushSettings = UIPushSettings}
