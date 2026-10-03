local UILLWorldMapTransport = {
  Name = UIWindowNames.UILLWorldMapTransport,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Landlord.MapTransport.Controller.UILLWorldMapTransportCtrl"),
  View = require("UI.Landlord.MapTransport.View.UILLWorldMapTransportView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/World/LLWorldMapTransport.prefab"
}
return {UILLWorldMapTransport = UILLWorldMapTransport}
