local UIDebugChooseServer = {
  Name = UIWindowNames.UIDebugChooseServer,
  Layer = UILayer.Info,
  Ctrl = require("UI.UILoading.UIDebugChooseServer.Controller.UIDebugChooseServerCtrl"),
  View = require("UI.UILoading.UIDebugChooseServer.View.UIDebugChooseServerView"),
  PrefabPath = "Assets/Main/Prefabs/Debug/UIDebugChooseServer.prefab"
}
return {UIDebugChooseServer = UIDebugChooseServer}
