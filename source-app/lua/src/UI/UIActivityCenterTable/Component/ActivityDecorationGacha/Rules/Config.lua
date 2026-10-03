local UIActivityDecorationGachaRules = {
  Name = UIWindowNames.UIActivityDecorationGachaRules,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActivityDecorationGacha.Rules.Ctrl.ActivityDecorationGachaRulesCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActivityDecorationGacha.Rules.View.ActivityDecorationGachaRulesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DecorationGacha/UIDecorationGachaRules.prefab"
}
return {UIActivityDecorationGachaRules = UIActivityDecorationGachaRules}
