local UIGovernmentServerBattleHistory = {
  Name = UIWindowNames.UIGovernmentServerBattleHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.ServerBattleHistory.Controller.ServerBattleHistoryCtrl"),
  View = require("UI.UIGovernment.ServerBattleHistory.View.ServerBattleHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/ServerBattleHistory.prefab"
}
return {UIGovernmentServerBattleHistory = UIGovernmentServerBattleHistory}
