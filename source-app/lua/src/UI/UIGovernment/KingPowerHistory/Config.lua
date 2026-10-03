local UIGovernmentKingPowerHistory = {
  Name = UIWindowNames.UIGovernmentKingPowerHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.KingPowerHistory.Controller.KingPowerHistoryCtrl"),
  View = require("UI.UIGovernment.KingPowerHistory.View.KingPowerHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/KingPowerHistory.prefab"
}
return {UIGovernmentKingPowerHistory = UIGovernmentKingPowerHistory}
