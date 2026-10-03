local LWUIChatOperation = {
  Name = UIWindowNames.LWUIChatOperation,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIChatOperation.Controller.LWUIChatOperationCtrl"),
  View = require("UI.LWUIChatOperation.View.LWUIChatOperationView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ChatNew/ChatOperation/LWUIChatOperationView.prefab"
}
return {LWUIChatOperation = LWUIChatOperation}
