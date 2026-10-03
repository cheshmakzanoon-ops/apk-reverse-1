local UILWSoldierDeadRateRule = {
  Name = UIWindowNames.UILWSoldierDeadRateRule,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWSoldierDeadRateRule.Controller.UILWSoldierDeadRateRuleCtrl"),
  View = require("UI.UILWSoldierDeadRateRule.View.UILWSoldierDeadRateRuleView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWMail/Soldier/UILWSoldierDeadRule.prefab"
}
return {UILWSoldierDeadRateRule = UILWSoldierDeadRateRule}
