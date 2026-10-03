local UIEpidemicBattleResult = {
  Name = UIWindowNames.UIEpidemicBattleResult,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleResult.Controller.UIEpidemicBattleResultCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleResult.View.UIEpidemicBattleResultView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleResult.prefab"
}
return {UIEpidemicBattleResult = UIEpidemicBattleResult}
