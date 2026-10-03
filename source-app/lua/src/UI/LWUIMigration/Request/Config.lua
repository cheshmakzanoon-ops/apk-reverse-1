local LWUIMigrationRequest = {
  Name = UIWindowNames.LWUIMigrationRequest,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.Request.Controller.LWUIMigrationRequestCtrl"),
  View = require("UI.LWUIMigration.Request.View.LWUIMigrationRequestView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigrationRequest.prefab"
}
return {LWUIMigrationRequest = LWUIMigrationRequest}
