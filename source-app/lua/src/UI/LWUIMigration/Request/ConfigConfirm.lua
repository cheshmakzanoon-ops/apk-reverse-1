local LWUIMigrationRequestConfirm = {
  Name = UIWindowNames.LWUIMigrationRequestConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIMigration.Request.Controller.LWUIMigrationRequestConfirmCtrl"),
  View = require("UI.LWUIMigration.Request.View.LWUIMigrationRequestConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIMigration/LWUIMigrationRequestConfirm.prefab"
}
return {LWUIMigrationRequestConfirm = LWUIMigrationRequestConfirm}
