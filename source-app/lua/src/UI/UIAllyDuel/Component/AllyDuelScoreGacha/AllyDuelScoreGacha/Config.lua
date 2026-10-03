local AllyDuelScoreGacha = {
  Name = UIWindowNames.AllyDuelScoreGacha,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIAllyDuel.Component.AllyDuelScoreGacha.AllyDuelScoreGacha.Controller.UIAllyDuelScoreGachaCtrl"),
  View = require("UI.UIAllyDuel.Component.AllyDuelScoreGacha.AllyDuelScoreGacha.View.UIAllyDuelScoreGacha"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllyDuel/AllyDuelScoreGacha/UIAllyDuelGachaPanel.prefab"
}
return {AllyDuelScoreGacha = AllyDuelScoreGacha}
