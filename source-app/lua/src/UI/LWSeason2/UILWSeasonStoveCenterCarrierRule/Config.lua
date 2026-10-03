local UILWSeasonStoveCenterCarrierRule = {
  Name = UIWindowNames.UILWSeasonStoveCenterCarrierRule,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.UILWSeasonStoveCenterCarrierRule.Controller.UILWSeasonStoveCenterCarrierRuleCtrl"),
  View = require("UI.LWSeason2.UILWSeasonStoveCenterCarrierRule.View.UILWSeasonStoveCenterCarrierRuleView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonStoveCenterCarrierRule.prefab"
}
return {UILWSeasonStoveCenterCarrierRule = UILWSeasonStoveCenterCarrierRule}
