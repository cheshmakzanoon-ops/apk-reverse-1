local UITrainKOFBattleResult = {
  Name = UIWindowNames.UITrainKOFBattleResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UITrainKOFBattleResult.Controller.UITrainKOFBattleResultCtrl"),
  View = require("UI.UITrainKOFBattleResult.View.UITrainKOFBattleResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UILWRailway/Scene/UITrainKOFBattleResult.prefab"
}
return {UITrainKOFBattleResult = UITrainKOFBattleResult}
