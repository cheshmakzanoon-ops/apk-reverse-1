local UIChampionDuelAward = {
  Name = UIWindowNames.UIChampionDuelAward,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.Award.Controller.UIChampionDuelAwardCtrl"),
  View = require("UI.UIChampionDuel.Award.View.UIChampionDuelAwardView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelAward.prefab"
}
return {UIChampionDuelAward = UIChampionDuelAward}
