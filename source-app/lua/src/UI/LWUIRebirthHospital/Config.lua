local LWUIRebirthHospital = {
  Name = UIWindowNames.LWUIRebirthHospital,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIRebirthHospital.Controller.LWUIRebirthHospitalCtrl"),
  View = require("UI.LWUIRebirthHospital.View.LWUIRebirthHospitalView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildDispatching/Hospital/Rebirth/LWUIRebirthHospital.prefab"
}
return {LWUIRebirthHospital = LWUIRebirthHospital}
