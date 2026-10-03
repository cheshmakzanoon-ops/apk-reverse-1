local UIRebirthHospitalHistory = {
  Name = UIWindowNames.UIRebirthHospitalHistory,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIRebirthHospitalHistory.Ctrl.LWUIRebirthHospitalHistoryCtrl"),
  View = require("UI.LWUIRebirthHospitalHistory.View.LWUIRebirthHospitalHistoryView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildDispatching/Hospital/Rebirth/LWUIRebirthHospitalHistory.prefab"
}
return {UIRebirthHospitalHistory = UIRebirthHospitalHistory}
