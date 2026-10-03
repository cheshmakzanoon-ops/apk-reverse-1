local LWUIActEasterEggMessage = {
  Name = UIWindowNames.LWUIActEasterEggMessage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActEasterEgg.LWUIActEasterEggMessage.Ctrl.LWUIActEasterEggMessageCtrl"),
  View = require("UI.LWUIActEasterEgg.LWUIActEasterEggMessage.View.LWUIActEasterEggMessageView"),
  PrefabPath = "Assets/Main/ActivityRes/2025EasterMod/Prefabs/UI/LWUIActEasterEggMessage.prefab"
}
return {LWUIActEasterEggMessage = LWUIActEasterEggMessage}
