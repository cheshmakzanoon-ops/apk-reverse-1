local UIChampionDuelGuessBet = {
  Name = UIWindowNames.UIChampionDuelGuessBet,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.GuessBet.Controller.UIChampionDuelGuessBetCtrl"),
  View = require("UI.UIChampionDuel.GuessBet.View.UIChampionDuelGuessBetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelGuessBet.prefab"
}
return {UIChampionDuelGuessBet = UIChampionDuelGuessBet}
