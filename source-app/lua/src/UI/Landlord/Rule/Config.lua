local UILLRule = {
  Name = UIWindowNames.UILLRule,
  Layer = UILayer.Normal,
  Ctrl = require("UI.Landlord.Rule.Ctrl.UILLRuleCtrl"),
  View = require("UI.Landlord.Rule.View.UILLRuleView"),
  PrefabPath = "Assets/Main/Prefabs/UI/Landlord/LLRulePanel.prefab"
}
return {UILLRule = UILLRule}
