local UIChampionDuelChangeBattleWord = {
  Name = UIWindowNames.UIChampionDuelChangeBattleWord,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.ChangeBattleWord.Controller.UIChangeBattleWordCtrl"),
  View = require("UI.UIChampionDuel.ChangeBattleWord.View.UIChangeBattleWordView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChangeBattleWord.prefab"
}
return {UIChampionDuelChangeBattleWord = UIChampionDuelChangeBattleWord}
