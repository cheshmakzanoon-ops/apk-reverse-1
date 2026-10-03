local UIAllyDrillReward = {
  Name = UIWindowNames.UIAllyDrillReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllyDrill.UIAllyDrillReward.Controller.UIAllyDrillRewardCtrl"),
  View = require("UI.UIAllyDrill.UIAllyDrillReward.View.UIAllyDrillRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/AllyDrill/UIAllyDrillReward.prefab"
}
return {UIAllyDrillReward = UIAllyDrillReward}
