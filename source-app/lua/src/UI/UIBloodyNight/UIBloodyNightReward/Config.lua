local UIBloodyNightReward = {
  Name = UIWindowNames.UIBloodyNightReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIBloodyNight.UIBloodyNightReward.Controller.UIBloodyNightRewardCtrl"),
  View = require("UI.UIBloodyNight.UIBloodyNightReward.View.UIBloodyNightRewardView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Activity/BloodyNight/UIBloodyNightReward.prefab"
}
return {UIBloodyNightReward = UIBloodyNightReward}
