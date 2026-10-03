local UILWDesertBattleTreatmentSoldier = {
  Name = UIWindowNames.UILWDesertBattleTreatmentSoldier,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UIActivityCenterTable.Component.DesertBattle.UILWTreatmentSoldier.Controller.LWUIDesertBattleTreatmentSoldierCtrl"),
  View = require("UI.UIActivityCenterTable.Component.DesertBattle.UILWTreatmentSoldier.View.LWUIDesertBattleTreatmentSoldierView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/DesertBattle/UILWDesertBattleTreatmentSoldierPanel.prefab"
}
return {UILWDesertBattleTreatmentSoldier = UILWDesertBattleTreatmentSoldier}
