local UIRocketFailedLanding = {
  Name = UIWindowNames.UIRocketFailedLanding,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIRocketFailedLanding.Controller.UIRocketFailedLandingCtrl"),
  View = require("UI.UIRocketFailedLanding.View.UIRocketFailedLandingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIRocketFailedLanding/UIRocketFailedLanding.prefab"
}
return {UIRocketFailedLanding = UIRocketFailedLanding}
