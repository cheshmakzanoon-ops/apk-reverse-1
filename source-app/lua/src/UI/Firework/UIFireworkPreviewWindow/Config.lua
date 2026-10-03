local UIFireworkPreviewWindow = {
  Name = UIWindowNames.UIFireworkPreviewWindow,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Firework.UIFireworkPreviewWindow.Controller.UIFireworkPreviewWindowCtrl"),
  View = require("UI.Firework.UIFireworkPreviewWindow.View.UIFireworkPreviewWindowView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUIFirework/UIFireworkPreviewWindowView.prefab"
}
return {UIFireworkPreviewWindow = UIFireworkPreviewWindow}
