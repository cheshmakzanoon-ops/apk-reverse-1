local LWUIMonsterInvasionRank = {
  Name = UIWindowNames.LWUIMonsterInvasionRank,
  Layer = UILayer.Normal,
  Ctrl = require("UI.MonsterInvasion.LWUIMonsterInvasionRank.Controller.LWUIMonsterInvasionRankCtrl"),
  View = require("UI.MonsterInvasion.LWUIMonsterInvasionRank.View.LWUIMonsterInvasionRankView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterInvasion/LWUIMonsterInvasionRankView.prefab"
}
return {LWUIMonsterInvasionRank = LWUIMonsterInvasionRank}
