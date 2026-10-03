local UILWBiuBiuCloud = {
  Name = UIWindowNames.UILWBiuBiuCloud,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWSeason5.UILWBiuBiuCloud.Controller.UILWBiuBiuCloudCtrl"),
  View = require("UI.LWSeason5.UILWBiuBiuCloud.View.UILWBiuBiuCloudView"),
  PrefabPath = "Assets/Main/MiniGameRes/BiuBiu/Prefab/UI/UILWBiuBiuCloud.prefab",
  CustomKeyCodeEscape = true
}
return {UILWBiuBiuCloud = UILWBiuBiuCloud}
