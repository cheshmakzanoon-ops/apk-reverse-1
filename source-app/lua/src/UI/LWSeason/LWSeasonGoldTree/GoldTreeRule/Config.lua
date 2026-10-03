local GoldTreeRule = {
  Name = UIWindowNames.GoldTreeRule,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWSeason.LWSeasonGoldTree.GoldTreeRule.GoldTreeRuleCtrl"),
  View = require("UI.LWSeason.LWSeasonGoldTree.GoldTreeRule.GoldTreeRuleView"),
  PrefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/GoldTree/GoldTreeRule.prefab"
}
return {GoldTreeRule = GoldTreeRule}
