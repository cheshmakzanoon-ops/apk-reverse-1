local BanquetAttackMonsterRankAndReward = {
  Name = UIWindowNames.BanquetAttackMonsterRankAndReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BanquetAttackMonster.BanquetAttackMonsterRankAndReward.Controller.BanquetAttackMonsterRankAndRewardCtrl"),
  View = require("UI.BanquetAttackMonster.BanquetAttackMonsterRankAndReward.View.BanquetAttackMonsterRankAndRewardView"),
  PrefabPath = "Assets/Main/ActivityFestival/ActBanquetAttackMonster/Prefab/BanquetAttackMonsterRankAndReward.prefab"
}
return {BanquetAttackMonsterRankAndReward = BanquetAttackMonsterRankAndReward}
