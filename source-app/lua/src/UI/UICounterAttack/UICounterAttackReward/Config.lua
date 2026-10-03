local UICounterAttackReward = {
  Name = UIWindowNames.UICounterAttackReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICounterAttack.UICounterAttackReward.Controller.UICounterAttackRewardCtrl"),
  View = require("UI.UICounterAttack.UICounterAttackReward.View.UICounterAttackRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/CounterAttack/UICounterAttackReward.prefab"
}
return {UICounterAttackReward = UICounterAttackReward}
