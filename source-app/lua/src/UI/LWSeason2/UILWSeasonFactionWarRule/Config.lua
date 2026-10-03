local UILWSeasonFactionWarRule = {
  Name = UIWindowNames.UILWSeasonFactionWarRule,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason2.UILWSeasonFactionWarRule.Controller.UILWSeasonFactionWarRuleCtrl"),
  View = require("UI.LWSeason2.UILWSeasonFactionWarRule.View.UILWSeasonFactionWarRuleView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWSeason2/SeasonActivity/FactionDeclareWarRule.prefab"
}
return {UILWSeasonFactionWarRule = UILWSeasonFactionWarRule}
