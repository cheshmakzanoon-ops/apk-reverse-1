local UIDigReward = {
  Name = UIWindowNames.UIDigReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDigReward.Controller.UIDigRewardCtrl"),
  View = require("UI.UIDigReward.View.UIDigRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIDigReward/UIDigReward.prefab"
}
return {UIDigReward = UIDigReward}
