local UIAlLeaderCongratulate = {
  Name = UIWindowNames.UIAlLeaderCongratulate,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAlLeaderCongratulate.Controller.UIAlLeaderCongratulateCtrl"),
  View = require("UI.UIAlliance.UIAlLeaderCongratulate.View.UIAlLeaderCongratulateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAlLeaderCongratulate.prefab"
}
return {UIAlLeaderCongratulate = UIAlLeaderCongratulate}
