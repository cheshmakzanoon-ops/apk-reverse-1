local BanquetAttackMonsterTask = {
  Name = UIWindowNames.BanquetAttackMonsterTask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BanquetAttackMonster.BanquetAttackMonsterTask.Controller.BanquetAttackMonsterTaskCtrl"),
  View = require("UI.BanquetAttackMonster.BanquetAttackMonsterTask.View.BanquetAttackMonsterTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/BanquetAttackMonsterTask.prefab"
}
return {BanquetAttackMonsterTask = BanquetAttackMonsterTask}
