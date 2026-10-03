local UIChampionDuelGuessList = {
  Name = UIWindowNames.UIChampionDuelGuessList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.GuessList.Controller.UIChampionDuelGuessListCtrl"),
  View = require("UI.UIChampionDuel.GuessList.View.UIChampionDuelGuessListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelGuessList.prefab"
}
return {UIChampionDuelGuessList = UIChampionDuelGuessList}
