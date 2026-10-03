local BanquetAttackMonsterLevelReward = {
  Name = UIWindowNames.BanquetAttackMonsterLevelReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BanquetAttackMonster.BanquetAttackMonsterLevelReward.Controller.BanquetAttackMonsterLevelRewardCtrl"),
  View = require("UI.BanquetAttackMonster.BanquetAttackMonsterLevelReward.View.BanquetAttackMonsterLevelRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/BanquetAttackMonsterLevelReward.prefab"
}
return {BanquetAttackMonsterLevelReward = BanquetAttackMonsterLevelReward}
