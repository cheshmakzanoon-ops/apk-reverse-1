local UIActMonopolyBoxReward = {
  Name = UIWindowNames.UIActMonopolyBoxReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.UIActMonopolyBoxReward.Controller.UIActMonopolyBoxRewardCtrl"),
  View = require("UI.UIActMonopoly.UIActMonopolyBoxReward.View.UIActMonopolyBoxRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActMonopolyBoxReward.prefab"
}
return {UIBuildList = UIActMonopolyBoxReward}
