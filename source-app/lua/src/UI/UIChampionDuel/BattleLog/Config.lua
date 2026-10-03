local UIChampionDuelBattleLog = {
  Name = UIWindowNames.UIChampionDuelBattleLog,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.BattleLog.Controller.UIChampionDuelBattleLogCtrl"),
  View = require("UI.UIChampionDuel.BattleLog.View.UIChampionDuelBattleLogView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelBattleLog.prefab"
}
return {UIChampionDuelBattleLog = UIChampionDuelBattleLog}
