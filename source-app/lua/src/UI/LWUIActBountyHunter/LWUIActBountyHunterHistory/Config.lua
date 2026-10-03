local LWUIActBountyHunterHistory = {
  Name = UIWindowNames.LWUIActBountyHunterHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActBountyHunter.LWUIActBountyHunterHistory.Ctrl.LWUIActBountyHunterHistoryCtrl"),
  View = require("UI.LWUIActBountyHunter.LWUIActBountyHunterHistory.View.LWUIActBountyHunterHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/RewardHistory/UIActBountyHunterHistory.prefab"
}
return {LWUIActBountyHunterHistory = LWUIActBountyHunterHistory}
