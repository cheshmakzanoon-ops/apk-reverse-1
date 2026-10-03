local UIEpidemicBattleStatus = {
  Name = UIWindowNames.UIEpidemicBattleStatus,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleStatus.Controller.UIEpidemicBattleStatusCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleStatus.View.UIEpidemicBattleStatusView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleStatus.prefab"
}
return {UIEpidemicBattleStatus = UIEpidemicBattleStatus}
