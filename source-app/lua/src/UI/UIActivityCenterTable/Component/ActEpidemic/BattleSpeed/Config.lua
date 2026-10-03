local UIEpidemicBattleSpeed = {
  Name = UIWindowNames.UIEpidemicBattleSpeed,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSpeed.Controller.UIEpidemicBattleSpeedCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleSpeed.View.UIEpidemicBattleSpeedView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleSpeed.prefab"
}
return {UIEpidemicBattleSpeed = UIEpidemicBattleSpeed}
