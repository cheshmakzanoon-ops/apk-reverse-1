local UILWGGGoCloud = {
  Name = UIWindowNames.UILWGGGoCloud,
  Layer = UILayer.Info,
  Ctrl = require("UI.LWSeason6.GGGo.Common.UILWGGGoCloud.Controller.UILWGGGoCloudCtrl"),
  View = require("UI.LWSeason6.GGGo.Common.UILWGGGoCloud.View.UILWGGGoCloudView"),
  PrefabPath = "Assets/Main/MiniGameRes/GGGo/Prefab/UI/UILWGGGoCloud.prefab",
  CustomKeyCodeEscape = true
}
return {UILWGGGoCloud = UILWGGGoCloud}
