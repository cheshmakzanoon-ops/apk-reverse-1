local UIInvasionSummonProgress = {
  Name = UIWindowNames.UIInvasionSummonProgress,
  Layer = UILayer.Info,
  Ctrl = require("UI.UIInvasionSummonProgress.Controller.UIInvasionSummonProgressCtrl"),
  View = require("UI.UIInvasionSummonProgress.View.UIInvasionSummonProgressView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/MonsterInvasion/UIInvasionSummonProgressView.prefab",
  AcquireHighFPSLockerForSeconds = 5
}
return {UIInvasionSummonProgress = UIInvasionSummonProgress}
