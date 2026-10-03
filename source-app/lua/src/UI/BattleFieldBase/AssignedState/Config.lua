local UIBattleFieldAssignedState = {
  Name = UIWindowNames.UIBattleFieldAssignedState,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BattleFieldBase.AssignedState.Ctrl.UIBattleFieldAssignedStateCtrl"),
  View = require("UI.BattleFieldBase.AssignedState.View.UIBattleFieldAssignedStateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BattleField/BattleFieldAssignedState.prefab"
}
return {UIBattleFieldAssignedState = UIBattleFieldAssignedState}
