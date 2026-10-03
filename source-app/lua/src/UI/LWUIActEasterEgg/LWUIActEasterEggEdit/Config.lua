local LWUIActEasterEggEditView = {
  Name = UIWindowNames.LWUIActEasterEggEditView,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActEasterEgg.LWUIActEasterEggEdit.Controller.LWUIActEasterEggEditCtrl"),
  View = require("UI.LWUIActEasterEgg.LWUIActEasterEggEdit.View.LWUIActEasterEggEditView"),
  PrefabPath = "Assets/Main/ActivityRes/2025EasterMod/Prefabs/UI/LWUIActEasterEggEditView.prefab"
}
return {LWUIActEasterEggEditView = LWUIActEasterEggEditView}
