local UIMultipleParkourResult = {
  Name = UIWindowNames.UIMultipleParkourResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIMultipleParkour.Result.Controller.UIMultipleParkourResultCtrl"),
  View = require("UI.UIMultipleParkour.Result.View.UIMultipleParkourResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/MultipleParkour/UIMultipleParkourResult.prefab"
}
return {UIMultipleParkourResult = UIMultipleParkourResult}
