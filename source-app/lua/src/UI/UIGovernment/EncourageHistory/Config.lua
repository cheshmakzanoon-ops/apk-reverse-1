local UIGovernmentEncourageHistory = {
  Name = UIWindowNames.UIGovernmentEncourageHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.EncourageHistory.Controller.EncourageHistoryCtrl"),
  View = require("UI.UIGovernment.EncourageHistory.View.EncourageHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/EncourageHistory.prefab"
}
return {UIGovernmentEncourageHistory = UIGovernmentEncourageHistory}
