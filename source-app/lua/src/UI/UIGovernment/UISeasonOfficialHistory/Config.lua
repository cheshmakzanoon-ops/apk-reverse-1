local UISeasonOfficialHistory = {
  Name = UIWindowNames.UISeasonOfficialHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.UISeasonOfficialHistory.UISeasonOfficialHistoryCtrl"),
  View = require("UI.UIGovernment.UISeasonOfficialHistory.UISeasonOfficialHistoryView"),
  PrefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/UISeasonOfficialHistory.prefab"
}
return {UISeasonOfficialHistory = UISeasonOfficialHistory}
