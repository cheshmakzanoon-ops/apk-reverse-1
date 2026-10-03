local LWUIMonsterInvasionReward = {
  Name = UIWindowNames.LWUIMonsterInvasionReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.MonsterInvasion.LWUIMonsterInvasionReward.Controller.LWUIMonsterInvasionRewardCtrl"),
  View = require("UI.MonsterInvasion.LWUIMonsterInvasionReward.View.LWUIMonsterInvasionRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterInvasion/LWUIMonsterInvasionRewardView.prefab"
}
return {LWUIMonsterInvasionReward = LWUIMonsterInvasionReward}
