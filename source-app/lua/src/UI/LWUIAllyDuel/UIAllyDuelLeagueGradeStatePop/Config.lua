local UIAllyDuelLeagueGradeStatePop = {
  Name = UIWindowNames.UIAllyDuelLeagueGradeStatePop,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIAllyDuel.UIAllyDuelLeagueGradeStatePop.Controller.UIAllyDuelLeagueGradeStatePopCtrl"),
  View = require("UI.LWUIAllyDuel.UIAllyDuelLeagueGradeStatePop.View.UIAllyDuelLeagueGradeStatePopView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIAllyDuel/UIAllyDuelLeagueGradePop.prefab"
}
return {UIAllyDuelLeagueGradeStatePop = UIAllyDuelLeagueGradeStatePop}
