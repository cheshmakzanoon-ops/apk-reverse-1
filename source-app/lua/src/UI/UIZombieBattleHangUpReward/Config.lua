local UIZombieBattleHangUpReward = {
  Name = UIWindowNames.UIZombieBattleHangUpReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIZombieBattleHangUpReward.Controller.UIZombieBattleHangUpRewardCtrl"),
  View = require("UI.UIZombieBattleHangUpReward.View.UIZombieBattleHangUpRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWStage/LWBattleHangUpRewardPanelNew.prefab"
}
return {UIZombieBattleHangUpReward = UIZombieBattleHangUpReward}
