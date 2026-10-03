local UILWBiuBiuRoom = {
  Name = UIWindowNames.UILWBiuBiuRoom,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.UILWBiuBiuRoom.Controller.UILWBiuBiuRoomCtrl"),
  View = require("UI.LWSeason5.UILWBiuBiuRoom.View.UILWBiuBiuRoomView"),
  PrefabPath = "Assets/Main/MiniGameRes/BiuBiu/Prefab/UI/UILWBiuBiuRoom.prefab",
  CustomKeyCodeEscape = true
}
return {UILWBiuBiuRoom = UILWBiuBiuRoom}
