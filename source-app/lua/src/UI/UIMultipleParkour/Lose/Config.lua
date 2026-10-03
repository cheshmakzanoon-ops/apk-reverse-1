local UIMultipleParkourLose = {
  Name = UIWindowNames.UIMultipleParkourLose,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMultipleParkour.Lose.Controller.UIMultipleParkourLoseCtrl"),
  View = require("UI.UIMultipleParkour.Lose.View.UIMultipleParkourLoseView"),
  PrefabPath = "Assets/Main/Prefabs/UI/MultipleParkour/UIMultipleParkourLose.prefab"
}
return {UIMultipleParkourLose = UIMultipleParkourLose}
