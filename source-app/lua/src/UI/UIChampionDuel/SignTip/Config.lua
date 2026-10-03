local UIChampionDuelSignTip = {
  Name = UIWindowNames.UIChampionDuelSignTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.SignTip.Controller.UIChampionDuelSignTipCtrl"),
  View = require("UI.UIChampionDuel.SignTip.View.UIChampionDuelSignTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelSignTipPop.prefab"
}
return {UIChampionDuelSignTip = UIChampionDuelSignTip}
