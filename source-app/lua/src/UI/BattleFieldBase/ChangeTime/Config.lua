local UIBattleFieldChangeTime = {
  Name = UIWindowNames.UIBattleFieldChangeTime,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BattleFieldBase.ChangeTime.Ctrl.UIBattleFieldChangeTimeCtrl"),
  View = require("UI.BattleFieldBase.ChangeTime.View.UIBattleFieldChangeTimeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BattleField/BattleFieldChangeTime.prefab"
}
return {UIBattleFieldChangeTime = UIBattleFieldChangeTime}
