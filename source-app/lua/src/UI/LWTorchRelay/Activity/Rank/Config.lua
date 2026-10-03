local TorchRelayRank = {
  Name = UIWindowNames.TorchRelayRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI/LWTorchRelay/Activity/Rank/Controller/UILWTorchRelayRankCtrl"),
  View = require("UI/LWTorchRelay/Activity/Rank/View/UILWTorchRelayRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/TorchRelay/Rank/UILWTorchRelayRank.prefab"
}
return {TorchRelayRank = TorchRelayRank}
