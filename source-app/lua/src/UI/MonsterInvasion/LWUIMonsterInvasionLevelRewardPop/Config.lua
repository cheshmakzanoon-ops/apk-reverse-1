local LWUIMonsterInvasionLevelRewardPop = {
  Name = UIWindowNames.LWUIMonsterInvasionLevelRewardPop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.MonsterInvasion.LWUIMonsterInvasionLevelRewardPop.Controller.LWUIMonsterInvasionLevelRewardPopCtrl"),
  View = require("UI.MonsterInvasion.LWUIMonsterInvasionLevelRewardPop.View.LWUIMonsterInvasionLevelRewardPopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterInvasion/LWUIMonsterInvasionLevelRewardPop.prefab"
}
return {LWUIMonsterInvasionLevelRewardPop = LWUIMonsterInvasionLevelRewardPop}
