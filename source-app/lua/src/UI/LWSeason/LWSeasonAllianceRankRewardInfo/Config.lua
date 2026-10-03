local LWSeasonAllianceRankRewardInfo = {
  Name = UIWindowNames.LWSeasonAllianceRankRewardInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonAllianceRankRewardInfo.Controller.LWSeasonAllianceRankRewardInfoCtrl"),
  View = require("UI.LWSeason.LWSeasonAllianceRankRewardInfo.View.LWSeasonAllianceRankRewardInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason/LWSeasonAllianceRankRewardInfo.prefab"
}
return {LWSeasonAllianceRankRewardInfo = LWSeasonAllianceRankRewardInfo}
