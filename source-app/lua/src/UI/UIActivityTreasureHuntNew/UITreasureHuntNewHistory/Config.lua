local UITreasureHuntNewHistory = {
  Name = UIWindowNames.UITreasureHuntNewHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UIActivityTreasureHuntNew/UITreasureHuntNewHistory/Controller/UITreasureHuntNewHistoryCtrl"),
  View = require("UI/UIActivityTreasureHuntNew/UITreasureHuntNewHistory/View/UITreasureHuntNewHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/TreasureHuntNew/UITreasureHuntNewHistory.prefab"
}
return {UITreasureHuntNewHistory = UITreasureHuntNewHistory}
