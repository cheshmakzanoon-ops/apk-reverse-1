local UIAlLeaderElectResult = {
  Name = UIWindowNames.UIAlLeaderElectResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAlLeaderElectResult.Controller.UIAlLeaderElectResultCtrl"),
  View = require("UI.UIAlliance.UIAlLeaderElectResult.View.UIAlLeaderElectResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAlLeaderElectResult.prefab"
}
return {UIAlLeaderElectResult = UIAlLeaderElectResult}
