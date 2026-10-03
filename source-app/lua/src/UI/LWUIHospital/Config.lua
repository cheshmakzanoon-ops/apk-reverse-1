local LWUIHospital = {
  Name = UIWindowNames.LWUIHospital,
  Layer = UILayer.Background,
  Ctrl = require("UI.LWUIHospital.Controller.LWUIHospitalCtrl"),
  View = require("UI.LWUIHospital.View.LWUIHospitalView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIBuildDispatching/Hospital/UIHospitalDetails.prefab"
}
return {LWUIHospital = LWUIHospital}
