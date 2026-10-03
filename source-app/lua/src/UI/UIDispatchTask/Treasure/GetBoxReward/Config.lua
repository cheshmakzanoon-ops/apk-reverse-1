local UIDispatchTreasureGetBoxReward = {
  Name = UIWindowNames.UIDispatchTreasureGetBoxReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIDispatchTask.Treasure.GetBoxReward.Controller.UIDispatchTreasureGetBoxRewardCtrl"),
  View = require("UI.UIDispatchTask.Treasure.GetBoxReward.View.UIDispatchTreasureGetBoxRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DispatchTreasure/UIDispatchTreasureGetBoxReward.prefab"
}
return {UIDispatchTreasureGetBoxReward = UIDispatchTreasureGetBoxReward}
