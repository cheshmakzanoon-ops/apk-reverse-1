local UIAllianceCompeteReward = {
  Name = UIWindowNames.UIAllianceCompeteReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllianceCompete.UIAllianceCompeteReward.Controller.UIAllianceCompeteRewardCtrl"),
  View = require("UI.UIAllianceCompete.UIAllianceCompeteReward.View.UIAllianceCompeteRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllianceCompeteNew/UIAllianceCompeteReward.prefab"
}
return {UIAllianceCompeteReward = UIAllianceCompeteReward}
