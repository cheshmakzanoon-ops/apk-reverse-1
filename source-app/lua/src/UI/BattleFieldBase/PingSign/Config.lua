local UIBattleFieldPingSign = {
  Name = UIWindowNames.UIBattleFieldPingSign,
  Layer = UILayer.Normal,
  Ctrl = require("UI.BattleFieldBase.PingSign.Ctrl.UIBattleFieldPingSignCtrl"),
  View = require("UI.BattleFieldBase.PingSign.View.UIBattleFieldPingSignView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BattleField/BattleFieldPingSign.prefab"
}
return {UIBattleFieldPingSign = UIBattleFieldPingSign}
