local UIDesertRules = {
  Name = UIWindowNames.UIDesertRules,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.Rules.Controller.UIDesertRulesCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.Rules.View.UIDesertRulesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/UIDesertRulesView.prefab"
}
return {UIDesertRules = UIDesertRules}
