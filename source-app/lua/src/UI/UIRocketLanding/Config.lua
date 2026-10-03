local UIRocketLanding = {
  Name = UIWindowNames.UIRocketLanding,
  Layer = UILayer.Guide,
  Ctrl = require("UI.UIRocketLanding.Controller.UIRocketLandingCtrl"),
  View = require("UI.UIRocketLanding.View.UIRocketLandingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIRocketLanding/UIRocketLanding.prefab"
}
return {UIRocketLanding = UIRocketLanding}
