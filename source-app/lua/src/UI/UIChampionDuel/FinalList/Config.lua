local UIChampionDuelFinalList = {
  Name = UIWindowNames.UIChampionDuelFinalList,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.FinalList.Controller.UIChampionDuelFinalListCtrl"),
  View = require("UI.UIChampionDuel.FinalList.View.UIChampionDuelFinalListView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelFinalList.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {UIChampionDuelFinalList = UIChampionDuelFinalList}
