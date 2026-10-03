local LWUIRedPacketDetails = {
  Name = UIWindowNames.LWUIRedPacketDetails,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIRedPacketDetails.Controller.LWUIRedPacketDetailsCtrl"),
  View = require("UI.LWUIRedPacketDetails.View.LWUIRedPacketDetailsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatRedPacket/LWUIRedPacketDetails.prefab"
}
return {LWUIRedPacketDetails = LWUIRedPacketDetails}
