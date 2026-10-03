local UIEpidemicBattleCommanderSet = {
  Name = UIWindowNames.UIEpidemicBattleCommanderSet,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleCommanderSet.Ctrl.UIEpidemicBattleCommanderSetCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleCommanderSet.View.UIEpidemicBattleCommanderSetView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleCommanderSet.prefab"
}
return {UIEpidemicBattleCommanderSet = UIEpidemicBattleCommanderSet}
