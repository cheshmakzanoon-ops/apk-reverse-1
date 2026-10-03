local UILWGGGoRoom = {
  Name = UIWindowNames.UILWGGGoRoom,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.GGGo.UILWGGGoRoom.Controller.UILWGGGoRoomCtrl"),
  View = require("UI.LWSeason6.GGGo.UILWGGGoRoom.View.UILWGGGoRoomView"),
  PrefabPath = "Assets/Main/MiniGameRes/GGGo/Prefab/UI/UILWGGGoRoom.prefab",
  CustomKeyCodeEscape = true
}
return {UILWGGGoRoom = UILWGGGoRoom}
