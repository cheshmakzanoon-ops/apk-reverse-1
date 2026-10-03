local LWUICommonRankReward = {
  Name = UIWindowNames.LWUICommonRankReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUICommonRankReward.Controller.LWUICommonRankRewardCtrl"),
  View = require("UI.LWUICommonRankReward.View.LWUICommonRankRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterInvasion/LWUIMonsterInvasionRewardView.prefab"
}
return {LWUICommonRankReward = LWUICommonRankReward}
