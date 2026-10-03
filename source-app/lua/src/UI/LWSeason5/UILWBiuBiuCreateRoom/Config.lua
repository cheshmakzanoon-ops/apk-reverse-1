local UILWBiuBiuCreateRoom = {
  Name = UIWindowNames.UILWBiuBiuCreateRoom,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.UILWBiuBiuCreateRoom.Controller.UILWBiuBiuCreateRoomCtrl"),
  View = require("UI.LWSeason5.UILWBiuBiuCreateRoom.View.UILWBiuBiuCreateRoomView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/BiuBiu/UILWBiuBiuCreateRoom.prefab",
  CustomKeyCodeEscape = true
}
return {UILWBiuBiuCreateRoom = UILWBiuBiuCreateRoom}
