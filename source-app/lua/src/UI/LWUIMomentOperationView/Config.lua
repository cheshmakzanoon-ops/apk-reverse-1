local LWUIMomentOperation = {
  Name = UIWindowNames.LWUIMomentOperation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMomentOperationView.Ctrl.LWUIMomentOperationCtrl"),
  View = require("UI.LWUIMomentOperationView.View.LWUIMomentOperationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatOperation/LWUIMomentOperationView.prefab"
}
return {LWUIMomentOperation = LWUIMomentOperation}
