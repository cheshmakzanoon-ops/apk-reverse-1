local UILWSeasonFactionWarHistory = {
  Name = UIWindowNames.UILWSeasonFactionWarHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.UILWSeasonFactionWarHistory.Controller.UILWSeasonFactionWarHistoryCtrl"),
  View = require("UI.LWSeason2.UILWSeasonFactionWarHistory.View.UILWSeasonFactionWarHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/FactionWarBattleHistory.prefab"
}
return {UILWSeasonFactionWarHistory = UILWSeasonFactionWarHistory}
