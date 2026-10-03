local UIMultipleParkourLoading = {
  Name = UIWindowNames.UIMultipleParkourLoading,
  Layer = UILayer.Dialog,
  Ctrl = require("UI.UIMultipleParkour.Loading.Controller.UIMultipleParkourLoadingCtrl"),
  View = require("UI.UIMultipleParkour.Loading.View.UIMultipleParkourLoadingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/MultipleParkour/UIMultipleParkourLoading.prefab",
  CustomKeyCodeEscape = true
}
return {UIMultipleParkourLoading = UIMultipleParkourLoading}
