local UIVoiceRoom = {
  Name = UIWindowNames.UIVoiceRoom,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatVoice.UIVoiceRoom.Controller.UIVoiceRoomCtrl"),
  View = require("UI.UIChatVoice.UIVoiceRoom.View.UIVoiceRoomView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatVoice/UIVoiceRoom.prefab",
  HideBack = true
}
return {UIVoiceRoom = UIVoiceRoom}
