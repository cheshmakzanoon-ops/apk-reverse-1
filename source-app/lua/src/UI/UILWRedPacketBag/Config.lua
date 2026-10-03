local UIRedPacketBag = {
  Name = UIWindowNames.UIRedPacketBag,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRedPacketBag.Controller.UILWIRedPacketBagCtrl"),
  View = require("UI.UILWRedPacketBag.View.UILWRedPacketBagView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatRedPacket/LWUIRedPacket.prefab"
}
return {UIRedPacketBag = UIRedPacketBag}
