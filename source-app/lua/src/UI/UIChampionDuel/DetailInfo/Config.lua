local UIChampionDuelDetailInfo = {
  Name = UIWindowNames.UIChampionDuelDetailInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.DetailInfo.Controller.UIChampionDuelDetailInfoCtrl"),
  View = require("UI.UIChampionDuel.DetailInfo.View.UIChampionDuelDetailInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelDetailInfo.prefab"
}
return {UIChampionDuelDetail = UIChampionDuelDetailInfo}
