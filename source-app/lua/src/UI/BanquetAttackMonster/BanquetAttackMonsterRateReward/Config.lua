local BanquetAttackMonsterRateReward = {
  Name = UIWindowNames.BanquetAttackMonsterRateReward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BanquetAttackMonster.BanquetAttackMonsterRateReward.Controller.BanquetAttackMonsterRateRewardCtrl"),
  View = require("UI.BanquetAttackMonster.BanquetAttackMonsterRateReward.View.BanquetAttackMonsterRateRewardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/BanquetAttackMonsterRateReward.prefab"
}
return {BanquetAttackMonsterRateReward = BanquetAttackMonsterRateReward}
