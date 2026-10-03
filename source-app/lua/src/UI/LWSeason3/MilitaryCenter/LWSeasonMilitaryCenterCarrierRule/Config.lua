local LWSeasonMilitaryCenterCarrierRule = {
  Name = UIWindowNames.LWSeasonMilitaryCenterCarrierRule,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason3.MilitaryCenter.LWSeasonMilitaryCenterCarrierRule.Controller.LWSeasonMilitaryCenterCarrierRuleCtrl"),
  View = require("UI.LWSeason3.MilitaryCenter.LWSeasonMilitaryCenterCarrierRule.View.LWSeasonMilitaryCenterCarrierRuleView"),
  PrefabPath = "Assets/Main/SeasonRes/S3/Prefabs/UI/LWSeason3/UIMilitaryCenter/SeasonMilitaryCenterCarrierRule.prefab"
}
return {LWSeasonMilitaryCenterCarrierRule = LWSeasonMilitaryCenterCarrierRule}
