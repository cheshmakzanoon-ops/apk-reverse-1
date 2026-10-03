local UIFrontBreakSundayRank = {
  Name = UIWindowNames.UIFrontBreakSundayRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFrontBreakSundayRank.Controller.UIFrontBreakSundayRankCtrl"),
  View = require("UI.UIFrontBreakSundayRank.View.UIFrontBreakSundayRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFrontBreakSunday/UIFrontBreakSundayRankView.prefab"
}
return {UIFrontBreakSundayRank = UIFrontBreakSundayRank}
