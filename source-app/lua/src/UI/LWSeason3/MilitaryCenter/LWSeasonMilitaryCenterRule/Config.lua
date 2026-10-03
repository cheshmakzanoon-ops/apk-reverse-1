local LWSeasonMilitaryCenterRule = {
  Name = UIWindowNames.LWSeasonMilitaryCenterRule,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason3.MilitaryCenter.LWSeasonMilitaryCenterRule.Controller.LWSeasonMilitaryCenterRuleCtrl"),
  View = require("UI.LWSeason3.MilitaryCenter.LWSeasonMilitaryCenterRule.View.LWSeasonMilitaryCenterRuleView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/UIMilitaryCenter/SeasonMilitaryCenterRule.prefab"
}
return {LWSeasonMilitaryCenterRule = LWSeasonMilitaryCenterRule}
