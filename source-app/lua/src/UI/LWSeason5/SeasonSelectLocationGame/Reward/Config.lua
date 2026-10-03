local SeasonSelectLocationGameReward = {
  Name = UIWindowNames.SeasonSelectLocationGameReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason5.SeasonSelectLocationGame.Reward.Ctrl.SeasonSelectLocationGameRewardCtrl"),
  View = require("UI.LWSeason5.SeasonSelectLocationGame.Reward.View.SeasonSelectLocationGameRewardView"),
  PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/UI/Activity/SeasonSelectLocationGame/SeasonSelectLocationGameReward.prefab"
}
return {SeasonSelectLocationGameReward = SeasonSelectLocationGameReward}
