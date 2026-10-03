local UIChampionDuelMain = {
  Name = UIWindowNames.UIChampionDuelMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.Controller.UIChampionDuelMainCtrl"),
  View = require("UI.UIChampionDuel.View.UIChampionDuelMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelMain.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {UIChampionDuelMain = UIChampionDuelMain}
