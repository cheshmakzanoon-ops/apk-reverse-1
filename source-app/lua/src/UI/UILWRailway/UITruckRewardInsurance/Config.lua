local UITruckRewardInsurance = {
  Name = UIWindowNames.UITruckRewardInsurance,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWRailway.UITruckRewardInsurance.Ctrl.UITruckRewardInsuranceCtrl"),
  View = require("UI.UILWRailway.UITruckRewardInsurance.View.UITruckRewardInsuranceView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UITruckRewardInsurance/UITruckRewardInsurance.prefab"
}
return {UITruckRewardInsurance = UITruckRewardInsurance}
