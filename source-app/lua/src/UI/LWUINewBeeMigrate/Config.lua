local LWUINewBeeMigrate = {
  Name = UIWindowNames.LWUINewBeeMigrate,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWUINewBeeMigrate.Controller.LWUINewBeeMigrateCtrl"),
  View = require("UI.LWUINewBeeMigrate.View.LWUINewBeeMigrateView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMainUI/LWUINewBeeMigrate.prefab",
  CustomKeyCodeEscape = true
}
return {LWUINewBeeMigrate = LWUINewBeeMigrate}
