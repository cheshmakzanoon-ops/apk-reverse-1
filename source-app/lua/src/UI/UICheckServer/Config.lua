local UICheckServer = {
  Name = UIWindowNames.UICheckServer,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UICheckServer.Controller.UICheckServerCtrl"),
  View = require("UI.UICheckServer.View.UICheckServerView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UICheckServer.prefab"
}
return {UICheckServer = UICheckServer}
