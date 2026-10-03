local UIGovernmentMain = {
  Name = UIWindowNames.UIGovernmentMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIGovernment.Main.Controller.MainCtrl"),
  View = require("UI.UIGovernment.Main.View.MainView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIGovernment/Main.prefab",
  HideBack = true
}
return {UIGovernmentMain = UIGovernmentMain}
