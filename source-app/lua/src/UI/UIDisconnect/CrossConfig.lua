local UICrossDisconnect = {
  Name = UIWindowNames.UICrossDisconnect,
  Layer = UILayer.TopMost,
  Ctrl = require("UI.UIDisconnect.Controller.UIDisconnectCtrl"),
  View = require("UI.UIDisconnect.View.UICrossDisconnectView"),
  PrefabPath = "Assets/Main/Prefabs/UI/DisconnectView.prefab"
}
return {UICrossDisconnect = UICrossDisconnect}
