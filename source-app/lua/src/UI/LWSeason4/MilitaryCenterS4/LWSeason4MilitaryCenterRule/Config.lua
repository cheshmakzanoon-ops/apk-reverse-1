local UILWSeason4CenterRule = {
  Name = UIWindowNames.UILWSeason4CenterRule,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason4.MilitaryCenterS4.LWSeason4MilitaryCenterRule.Controller.LWSeason4MilitaryCenterRuleCtrl"),
  View = require("UI.LWSeason4.MilitaryCenterS4.LWSeason4MilitaryCenterRule.View.LWSeason4MilitaryCenterRuleView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/UIMilitaryCenter/SeasonMilitaryCenterRule.prefab"
}
return {UILWSeason4CenterRule = UILWSeason4CenterRule}
