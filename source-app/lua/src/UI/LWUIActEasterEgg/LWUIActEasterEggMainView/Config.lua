local LWUIActEasterEggMain = {
  Name = UIWindowNames.LWUIActEasterEggMain,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActEasterEgg.LWUIActEasterEggMainView.Controller.LWUIActEasterEggMainViewCtrl"),
  View = require("UI.LWUIActEasterEgg.LWUIActEasterEggEdit.Component.LWUIActEasterEggMainView"),
  PrefabPath = "Assets/Main/ActivityRes/2025EasterMod/Prefabs/UI/LWUIActEasterEggMainView.prefab"
}
return {LWUIActEasterEggMain = LWUIActEasterEggMain}
