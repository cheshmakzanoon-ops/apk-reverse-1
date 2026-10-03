local UIChannelSetting = {
  Name = UIWindowNames.UIChannelSetting,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatNew.UIChannelSetting.Controller.UIChannelSettingCtrl"),
  View = require("UI.UIChatNew.UIChannelSetting.View.UIChannelSettingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/UIChannelSetting.prefab"
}
return {UIChannelSetting = UIChannelSetting}
