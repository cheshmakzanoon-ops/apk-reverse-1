local UILUISheepCloud = {
  Name = UIWindowNames.UILUISheepCloud,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWSeason4.UILUISheepCloud.Controller.UILUISheepCloudCtrl"),
  View = require("UI.LWSeason4.UILUISheepCloud.View.UILUISheepCloudView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/LWSheep/UILUISheepCloud.prefab",
  CustomKeyCodeEscape = true
}
return {UILUISheepCloud = UILUISheepCloud}
