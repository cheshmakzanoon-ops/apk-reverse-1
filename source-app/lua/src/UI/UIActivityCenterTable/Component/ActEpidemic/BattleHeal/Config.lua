local UIEpidemicBattleHeal = {
  Name = UIWindowNames.UIEpidemicBattleHeal,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleHeal.Controller.UIEpidemicBattleHealCtrl"),
  View = require("UI.UIActivityCenterTable.Component.ActEpidemic.BattleHeal.View.UIEpidemicBattleHealView"),
  PrefabPath = "Assets/Main/Prefabs/UI/BF_Epidemic/Battle/BattleHeal.prefab"
}
return {UIEpidemicBattleHeal = UIEpidemicBattleHeal}
