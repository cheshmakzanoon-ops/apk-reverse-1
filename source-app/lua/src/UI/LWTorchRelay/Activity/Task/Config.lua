local UITorchRelayTaskView = {
  Name = UIWindowNames.UITorchRelayTaskView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWTorchRelay.Activity.Task.Ctrl.UITorchRelayTaskCtrl"),
  View = require("UI.LWTorchRelay.Activity.Task.View.UITorchRelayTaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/TorchRelay/Main/UITorchRelayTask.prefab"
}
return {UITorchRelayTaskView = UITorchRelayTaskView}
