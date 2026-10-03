local LWUINewBeeMigrateLoading = {
  Name = UIWindowNames.LWUINewBeeMigrateLoading,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWUINewBeeMigrate.Controller.LWUINewBeeMigrateCtrl"),
  View = require("UI.LWUINewBeeMigrate.View.LWUINewBeeMigrateLoadingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMainUI/LWUINewBeeMigrateLoading.prefab",
  CustomKeyCodeEscape = true
}
return {LWUINewBeeMigrateLoading = LWUINewBeeMigrateLoading}
