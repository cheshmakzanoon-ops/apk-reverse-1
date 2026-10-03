local UIChatRoomCellOperatorView = {
  Name = UIWindowNames.UIChatRoomCellOperatorView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChatRoomCellOperatorView.Controller.UIChatRoomCellOperatorCtrl"),
  View = require("UI.UIChatRoomCellOperatorView.View.UIChatRoomCellOperatorView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatRoomCellOperator/UIChatRoomCellOperator.prefab"
}
return {UIChatRoomCellOperatorView = UIChatRoomCellOperatorView}
