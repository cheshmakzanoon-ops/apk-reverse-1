local TorchRelayCheerInfo = {
  Name = UIWindowNames.TorchRelayCheerInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTorchRelay.Activity.CheerInfo.Ctrl.UILWTorchRelayCheerCtrl"),
  View = require("UI.LWTorchRelay.Activity.CheerInfo.View.UILWTorchRelayCheerView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/TorchRelay/Main/UILWTorchRelayCheer.prefab"
}
return {TorchRelayCheerInfo = TorchRelayCheerInfo}
