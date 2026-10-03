local TorchRelayGrowUp = {
  Name = UIWindowNames.TorchRelayGrowUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTorchRelay.Activity.GrowUp.Control.UILWTorchRelayGrowUpCtrl"),
  View = require("UI.LWTorchRelay.Activity.GrowUp.View.UILWTorchRelayGrowUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/TorchRelay/Main/UILWTorchRelayGrowUp.prefab"
}
return {TorchRelayGrowUp = TorchRelayGrowUp}
