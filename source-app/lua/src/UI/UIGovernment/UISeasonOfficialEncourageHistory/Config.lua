local UISeasonOfficialEncourageHistory = {
  Name = UIWindowNames.UISeasonOfficialEncourageHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialEncourageHistory.UISeasonOfficialEncourageHistoryCtrl"),
  View = require("UI.UIGovernment.UISeasonOfficialEncourageHistory.UISeasonOfficialEncourageHistoryView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialEncourageHistory.prefab"
}
return {UISeasonOfficialEncourageHistory = UISeasonOfficialEncourageHistory}
