local UILWSeasonStoveCenterRule = {
  Name = UIWindowNames.UILWSeasonStoveCenterRule,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.UILWSeasonStoveCenterRule.Controller.UILWSeasonStoveCenterRuleCtrl"),
  View = require("UI.LWSeason2.UILWSeasonStoveCenterRule.View.UILWSeasonStoveCenterRuleView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonStoveCenterRule.prefab"
}
return {UILWSeasonStoveCenterRule = UILWSeasonStoveCenterRule}
