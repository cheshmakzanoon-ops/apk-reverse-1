local UIBanquetItemDropProbability = {
  Name = UIWindowNames.UIBanquetItemDropProbability,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BanquetAttackMonster.UIBanquetItemDropProbability.Controller.UIBanquetItemDropProbabilityCtrl"),
  View = require("UI.BanquetAttackMonster.UIBanquetItemDropProbability.View.UIBanquetItemDropProbabilityView"),
  PrefabPath = "Assets/Main/ActivityFestival/ActBanquetAttackMonster/Prefab/UIBanquetItemDropProbability/UIBanquetItemDropProbability.prefab"
}
return {UIBanquetItemDropProbability = UIBanquetItemDropProbability}
