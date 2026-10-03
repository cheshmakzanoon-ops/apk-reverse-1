local LWUIArenaSoldierConfirmView = {
  Name = UIWindowNames.LWPVPArenaSoldierConfirm,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWPVPArena.SoldierConfirmView.Controller.LWUIArenaSoldierConfirmViewCtrl"),
  View = require("UI.LWPVPArena.SoldierConfirmView.View.LWUIArenaSoldierConfirmView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPVPArena/LWPVPArenaSoldierPowerConfirmViewPanel.prefab"
}
return {LWUIArenaSoldierConfirmView = LWUIArenaSoldierConfirmView}
