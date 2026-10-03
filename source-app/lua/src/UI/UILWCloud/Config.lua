local UILWCloud = {
  Name = UIWindowNames.UILWCloud,
  Layer = UILayer.Info,
  Ctrl = require("UI.UILWCloud.Controller.UILWCloudCtrl"),
  View = require("UI.UILWCloud.View.UILWCloudView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWCloud/UILWCloud.prefab",
  CustomKeyCodeEscape = true
}
return {UILWCloud = UILWCloud}
