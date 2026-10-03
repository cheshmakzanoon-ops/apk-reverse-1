local TorchRelayBattleWin = {
  Name = UIWindowNames.TorchRelayBattleWin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTorchRelay.Battle.Win.Ctrl.UILWTorchRelayBattleWinCtrl"),
  View = require("UI.LWTorchRelay.Battle.Win.View.UILWTorchRelayBattleWinView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/TorchRelay/Battle/UILWTorchRelayBattleWin.prefab"
}
return {TorchRelayBattleWin = TorchRelayBattleWin}
