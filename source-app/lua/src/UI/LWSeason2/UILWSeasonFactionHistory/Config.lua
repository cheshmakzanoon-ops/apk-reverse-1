local UILWSeasonFactionHistory = {
  Name = UIWindowNames.UILWSeasonFactionHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.UILWSeasonFactionHistory.Controller.UILWSeasonFactionHistoryCtrl"),
  View = require("UI.LWSeason2.UILWSeasonFactionHistory.View.UILWSeasonFactionHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/FactionHistory.prefab"
}
return {UILWSeasonFactionHistory = UILWSeasonFactionHistory}
