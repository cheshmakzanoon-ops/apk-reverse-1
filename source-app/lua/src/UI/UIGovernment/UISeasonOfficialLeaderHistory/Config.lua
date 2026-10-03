local UISeasonOfficialLeaderHistory = {
  Name = UIWindowNames.UISeasonOfficialLeaderHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialLeaderHistory.UISeasonOfficialLeaderHistoryCtrl"),
  View = require("UI.UIGovernment.UISeasonOfficialLeaderHistory.UISeasonOfficialLeaderHistoryView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialLeaderHistory.prefab"
}
return {UISeasonOfficialLeaderHistory = UISeasonOfficialLeaderHistory}
