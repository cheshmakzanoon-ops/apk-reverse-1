local TorchRelayBattleMain = {
  Name = UIWindowNames.TorchRelayBattleMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTorchRelay.Battle.Main.Ctrl.UILWTorchRelayBattleMainCtrl"),
  View = require("UI.LWTorchRelay.Battle.Main.View.UILWTorchRelayBattleMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/TorchRelay/Battle/UILWTorchRelayBattleMain.prefab"
}
return {TorchRelayBattleMain = TorchRelayBattleMain}
