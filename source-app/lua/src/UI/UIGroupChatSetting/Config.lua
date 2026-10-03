local UIGroupChatSetting = {
  Name = UIWindowNames.UIGroupChatSetting,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGroupChatSetting.Ctrl.UIGroupChatSettingCtrl"),
  View = require("UI.UIGroupChatSetting.View.UIGroupChatSettingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/GroupChat/UIGroupChatSetting.prefab"
}
return {UIGroupChatSetting = UIGroupChatSetting}
