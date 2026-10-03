local UITrain3V3BattleResult = {
  Name = UIWindowNames.UITrain3V3BattleResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UITrain3V3BattleResult.Controller.UITrain3V3BattleResultCtrl"),
  View = require("UI.UITrain3V3BattleResult.View.UITrain3V3BattleResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/UITrain3V3BattleResult.prefab"
}
return {UITrain3V3BattleResult = UITrain3V3BattleResult}
