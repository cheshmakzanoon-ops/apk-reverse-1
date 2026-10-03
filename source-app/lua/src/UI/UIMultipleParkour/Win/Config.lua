local UIMultipleParkourWin = {
  Name = UIWindowNames.UIMultipleParkourWin,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMultipleParkour.Win.Controller.UIMultipleParkourWinCtrl"),
  View = require("UI.UIMultipleParkour.Win.View.UIMultipleParkourWinView"),
  PrefabPath = "Assets/Main/Prefabs/UI/MultipleParkour/UIMultipleParkourWin.prefab"
}
return {UIMultipleParkourWin = UIMultipleParkourWin}
