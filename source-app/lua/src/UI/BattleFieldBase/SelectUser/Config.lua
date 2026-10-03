local UIBattleFieldBaseSelectUser = {
  Name = UIWindowNames.UIBattleFieldBaseSelectUser,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BattleFieldBase.SelectUser.Ctrl.UIBFBaseSelectUserCtrl"),
  View = require("UI.BattleFieldBase.SelectUser.View.UIBFBaseSelectUserView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BattleField/BattleFieldBaseSelectUser/SelectUser.prefab"
}
return {UIBattleFieldBaseSelectUser = UIBattleFieldBaseSelectUser}
