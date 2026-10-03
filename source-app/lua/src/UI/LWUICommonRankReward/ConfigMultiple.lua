local LWUICommonRankMultipleReward = {
  Name = UIWindowNames.LWUICommonRankMultipleReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUICommonRankReward.Controller.LWUICommonRankMultipleRewardCtrl"),
  View = require("UI.LWUICommonRankReward.View.LWUICommonRankMultipleRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterInvasion/LWUIMonsterInvasionMultipleRewardView.prefab"
}
return {LWUICommonRankMultipleReward = LWUICommonRankMultipleReward}
