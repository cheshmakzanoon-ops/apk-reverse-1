local UIAllyDuelLeagueHistory = {
  Name = UIWindowNames.UIAllyDuelLeagueHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIAllyDuel.UIAllyDuelLeagueHistory.Controller.UIAllyDuelLeagueHistoryCtrl"),
  View = require("UI.LWUIAllyDuel.UIAllyDuelLeagueHistory.View.UIAllyDuelLeagueHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllyDuel/UIAllyDuelLeagueHistory.prefab"
}
return {UIAllyDuelLeagueHistory = UIAllyDuelLeagueHistory}
