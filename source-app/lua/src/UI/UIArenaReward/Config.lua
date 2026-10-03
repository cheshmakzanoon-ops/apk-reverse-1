local UIArenaReward = {
  Name = UIWindowNames.UIArenaReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIArenaReward.Controller.UIArenaRewardCtrl"),
  View = require("UI.UIArenaReward.View.UIArenaRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Arena/UIArenaReward.prefab"
}
return {UIArenaReward = UIArenaReward}
