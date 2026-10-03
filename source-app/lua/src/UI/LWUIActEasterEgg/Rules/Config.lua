local UIActEasterEggRules = {
  Name = UIWindowNames.UIActEasterEggRules,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActEasterEgg.Rules.Ctrl.UIActEasterEggRulesCtrl"),
  View = require("UI.LWUIActEasterEgg.Rules.View.UIActEasterEggRulesView"),
  PrefabPath = "Assets/Main/ActivityRes/2025EasterMod/Prefabs/UI/UIActEasterEggRules.prefab"
}
return {UIActEasterEggRules = UIActEasterEggRules}
