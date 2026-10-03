local UIChooseServer = {
  Name = UIWindowNames.UIChooseServer,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UIChooseServer.Controller.UIChooseServerCtrl"),
  View = require("UI.UISetting.UIChooseServer.View.UIChooseServerView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UIChooseServer.prefab"
}
return {UIChooseServer = UIChooseServer}
