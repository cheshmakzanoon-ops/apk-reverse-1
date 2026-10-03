local UIAlLeaderElectSignUp = {
  Name = UIWindowNames.UIAlLeaderElectSignUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAlliance.UIAlLeaderElectSignUp.Controller.UIAlLeaderElectSignUpCtrl"),
  View = require("UI.UIAlliance.UIAlLeaderElectSignUp.View.UIAlLeaderElectSignUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Alliance/UIAlLeaderElectSignUp.prefab"
}
return {UIAlLeaderElectSignUp = UIAlLeaderElectSignUp}
