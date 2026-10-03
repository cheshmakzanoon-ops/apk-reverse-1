local UIBattleFieldSelectTime = {
  Name = UIWindowNames.UIBattleFieldSelectTime,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BattleFieldBase.SelectTime.Ctrl.UIBattleFieldSelectTimeCtrl"),
  View = require("UI.BattleFieldBase.SelectTime.View.UIBattleFieldSelectTimeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BattleField/BattleFieldSelectTime.prefab"
}
return {UIBattleFieldSelectTime = UIBattleFieldSelectTime}
