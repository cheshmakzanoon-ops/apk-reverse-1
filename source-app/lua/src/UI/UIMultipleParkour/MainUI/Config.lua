local UIMultipleParkour = {
  Name = UIWindowNames.UIMultipleParkour,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMultipleParkour.MainUI.Controller.UIMultipleParkourCtrl"),
  View = require("UI.UIMultipleParkour.MainUI.View.UIMultipleParkourView"),
  PrefabPath = "Assets/Main/Prefabs/UI/MultipleParkour/UIMultipleParkour.prefab"
}
return {UIMultipleParkour = UIMultipleParkour}
