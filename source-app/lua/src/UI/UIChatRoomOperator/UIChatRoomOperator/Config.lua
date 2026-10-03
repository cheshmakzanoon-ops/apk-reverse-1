local UIChatRoomOperator = {
  Name = UIWindowNames.UIChatRoomOperator,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatRoomOperator.UIChatRoomOperator.Controller.UIChatRoomOperatorCtrl"),
  View = require("UI.UIChatRoomOperator.UIChatRoomOperator.View.UIChatRoomOperatorView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/RoomOperator/UIChatRoomOperator.prefab"
}
return {UIChatRoomOperator = UIChatRoomOperator}
