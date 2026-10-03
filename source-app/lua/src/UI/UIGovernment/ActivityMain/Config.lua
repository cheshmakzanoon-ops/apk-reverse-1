local UIGovernmentActivityMain = {
  Name = UIWindowNames.UIGovernmentActivityMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.ActivityMain.Controller.ActivityMainCtrl"),
  View = require("UI.UIGovernment.ActivityMain.View.ActivityMainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/ActivityMain.prefab"
}
return {UIGovernmentActivityMain = UIGovernmentActivityMain}
