local UILWGGGoCreateRoom = {
  Name = UIWindowNames.UILWGGGoCreateRoom,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason6.GGGo.UILWGGGoCreateRoom.Controller.UILWGGGoCreateRoomCtrl"),
  View = require("UI.LWSeason6.GGGo.UILWGGGoCreateRoom.View.UILWGGGoCreateRoomView"),
  PrefabPath = "Assets/Main/SeasonRes/S6/Prefabs/GGGo/UILWGGGoCreateRoom.prefab",
  CustomKeyCodeEscape = true
}
return {UILWGGGoCreateRoom = UILWGGGoCreateRoom}
