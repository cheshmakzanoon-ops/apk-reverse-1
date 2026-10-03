local UIChampionDuelDonateConfirm = {
  Name = UIWindowNames.UIChampionDuelDonateConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.UIChampionDuelDonateConfirm.Controller.UIChampionDuelDonateConfirmCtrl"),
  View = require("UI.UIChampionDuel.UIChampionDuelDonateConfirm.View.UIChampionDuelDonateConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelDonateConfirm.prefab"
}
return {UIChampionDuelDonateConfirm = UIChampionDuelDonateConfirm}
