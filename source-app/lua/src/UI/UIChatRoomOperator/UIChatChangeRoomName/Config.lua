local UIChatChangeRoomName = {
  Name = UIWindowNames.UIChatChangeRoomName,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UIChatRoomOperator.UIChatChangeRoomName.Controller.UIChatChangeRoomNameCtrl"),
  View = require("UI.UIChatRoomOperator.UIChatChangeRoomName.View.UIChatChangeRoomNameView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/RoomOperator/UIChatChangeRoomName.prefab"
}
return {UIChatChangeRoomName = UIChatChangeRoomName}
