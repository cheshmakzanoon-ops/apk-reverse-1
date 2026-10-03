local UIHospital = {
  Name = UIWindowNames.UIHospital,
  Layer = UILayer.Background,
  Ctrl = require("UI.UIHospital.Controller.UIHospitalCtrl"),
  View = require("UI.UIHospital.View.UIHospitalView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UIRepair/UIRepairPanel.prefab"
}
return {UIHospital = UIHospital}
