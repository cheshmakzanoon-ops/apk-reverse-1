local UIParkourDetectRetryTaskResult = {
  Name = UIWindowNames.UIParkourBonusResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIParkour.DetectRetryTaskResultUI.Ctrl.UIParkourDetectRetryTaskResultCtrl"),
  View = require("UI.UIParkour.DetectRetryTaskResultUI.View.UIParkourDetectRetryTaskResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ParkourBattle/UIParkourDetectRetryTaskResult.prefab"
}
return {UIParkourDetectRetryTaskResult = UIParkourDetectRetryTaskResult}
