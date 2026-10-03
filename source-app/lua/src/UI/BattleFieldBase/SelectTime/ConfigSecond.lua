local UIBattleFieldSelectTimeSecond = {
  Name = UIWindowNames.UIBattleFieldSelectTimeSecond,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BattleFieldBase.SelectTime.Ctrl.UIBattleFieldSelectTimeSecondCtrl"),
  View = require("UI.BattleFieldBase.SelectTime.View.UIBattleFieldSelectTimeSecondView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BattleField/BattleFieldSelectTimeSecond.prefab"
}
return {UIBattleFieldSelectTimeSecond = UIBattleFieldSelectTimeSecond}
