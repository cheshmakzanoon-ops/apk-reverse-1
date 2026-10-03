local UIAllianceStarReward = {
  Name = UIWindowNames.UIAllianceStarReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI/UIAllianceStarReward/Controller/UIAllianceStarRewardCtrl"),
  View = require("UI/UIAllianceStarReward/View/UIAllianceStarRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceStar/UIAllianceStarReward.prefab"
}
return {UIAllianceStarReward = UIAllianceStarReward}
