local UICityEventCityFightReward = {
  Name = UIWindowNames.UICityEventCityFightReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICItyEventCityFightReward.LWCityEventCityFightRewardCtrl"),
  View = require("UI.UICItyEventCityFightReward.LWCityEventCityFightReward"),
  PrefabPath = "Assets/Main/Prefabs/UI/UICityEvent/UICityEventCityFightReward.prefab"
}
return {UICityEventCityFightReward = UICityEventCityFightReward}
