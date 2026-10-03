local SeasonHunterHistory = {
  Name = UIWindowNames.SeasonHunterHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonHunter.SeasonHunterHistory.SeasonHunterHistoryCtrl"),
  View = require("UI.LWSeason.LWSeasonHunter.SeasonHunterHistory.SeasonHunterHistoryView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/SeasonHunterHistory.prefab"
}
return {SeasonHunterHistory = SeasonHunterHistory}
