local UIChampionDuelDetail = {
  Name = UIWindowNames.UIChampionDuelDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.Detail.Controller.UIChampionDuelDetailCtrl"),
  View = require("UI.UIChampionDuel.Detail.View.UIChampionDuelDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelDetail.prefab"
}
return {UIChampionDuelDetail = UIChampionDuelDetail}
