local UIVoicePrivacyBox = {
  Name = UIWindowNames.UIVoicePrivacyBox,
  Layer = UILayer.Dialog,
  Model = nil,
  Ctrl = require("UI.UIChatVoice.UIVoicePrivacyBox.Controller.UIVoicePrivacyBoxCtrl"),
  View = require("UI.UIChatVoice.UIVoicePrivacyBox.View.UIVoicePrivacyBoxView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatVoice/UIVoicePrivacyBox.prefab"
}
return {UIVoicePrivacyBox = UIVoicePrivacyBox}
