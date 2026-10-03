local AllyDuelScoreGachaRules = {
  Name = UIWindowNames.AllyDuelScoreGachaRules,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllyDuel.Component.AllyDuelScoreGacha.AllyDuelScoreGachaRules.Ctrl.AllyDuelScoreGachaRulesCtrl"),
  View = require("UI.UIAllyDuel.Component.AllyDuelScoreGacha.AllyDuelScoreGachaRules.View.AllyDuelScoreGachaRulesView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelScoreGacha/UIAllyDuelGachaRules.prefab"
}
return {AllyDuelScoreGachaRules = AllyDuelScoreGachaRules}
