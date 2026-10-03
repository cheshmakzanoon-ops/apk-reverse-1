local CampSelectHistory = {
  Name = UIWindowNames.CampSelectHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonCampWar.CampSelectHistory.CampSelectHistoryCtrl"),
  View = require("UI.LWSeason.LWSeasonCampWar.CampSelectHistory.CampSelectHistoryView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/CampSelection/CampSelectHistory.prefab"
}
return {CampSelectHistory = CampSelectHistory}
