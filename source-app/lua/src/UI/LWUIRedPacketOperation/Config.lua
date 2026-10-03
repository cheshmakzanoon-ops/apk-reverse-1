local LWUIRedPacketOperation = {
  Name = UIWindowNames.LWUIRedPacketOperation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIRedPacketOperation.Controller.LWUIRedPacketOperationCtrl"),
  View = require("UI.LWUIRedPacketOperation.View.LWUIRedPacketOperationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatRedPacket/LWUIRedPacketOperation.prefab"
}
return {LWUIRedPacketOperation = LWUIRedPacketOperation}
