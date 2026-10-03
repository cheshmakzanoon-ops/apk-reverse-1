local UIChatRedDotSetting = {
  Name = UIWindowNames.UIChatRedDotSetting,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatRedDotSetting.Controller.UIChatRedDotSettingCtrl"),
  View = require("UI.UIChatRedDotSetting.View.UIChatRedDotSettingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/UIChatRedDotSetting.prefab"
}
return {UIChatRedDotSetting = UIChatRedDotSetting}
