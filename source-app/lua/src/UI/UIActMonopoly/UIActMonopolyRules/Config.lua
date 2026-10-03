local UIActMonopolyRules = {
  Name = UIWindowNames.UIActMonopolyRules,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActMonopoly.UIActMonopolyRules.Ctrl.UIActMonopolyRulesCtrl"),
  View = require("UI.UIActMonopoly.UIActMonopolyRules.View.UIActMonopolyRulesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/ActMonopoly/UIActMonopolyRules.prefab"
}
return {UIActMonopolyRules = UIActMonopolyRules}
