local UIFrontBreakSundayRankReward = {
  Name = UIWindowNames.UIFrontBreakSundayRankReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIFrontBreakSundayRankReward.Controller.UIFrontBreakSundayRankRewardCtrl"),
  View = require("UI.UIFrontBreakSundayRankReward.View.UIFrontBreakSundayRankRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIFrontBreakSunday/UIFrontBreakSundayRankRewardView.prefab"
}
return {UIFrontBreakSundayRankReward = UIFrontBreakSundayRankReward}
