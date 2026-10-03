local UIActSevenDayV2Reward = {
  Name = UIWindowNames.UIActSevenDayV2Reward,
  Layer = UILayer.Normal,
  Ctrl = require("UI/LWUIActSevenDayV2/Reward/Controller/UIActSevenDayV2RewardCtrl"),
  View = require("UI/LWUIActSevenDayV2/Reward/View/UIActSevenDayV2RewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWActSevenDayV2/ActSevenDayV2RewardView.prefab"
}
return {UIActSevenDayV2Reward = UIActSevenDayV2Reward}
