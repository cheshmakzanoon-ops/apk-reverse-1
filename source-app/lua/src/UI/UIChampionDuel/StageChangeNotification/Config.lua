local UIChampionDuelStageChangeNotification = {
  Name = UIWindowNames.UIChampionDuelStageChangeNotification,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIChampionDuel.StageChangeNotification.Controller.UIChampionDuelStageChangeNotificationCtrl"),
  View = require("UI.UIChampionDuel.StageChangeNotification.View.UIChampionDuelStageChangeNotificationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIChampionDuel/UIChampionDuelStageChangeNotification.prefab"
}
return {UIChampionDuelStageChangeNotification = UIChampionDuelStageChangeNotification}
