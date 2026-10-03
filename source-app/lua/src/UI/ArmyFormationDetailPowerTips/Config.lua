local ArmyFormationDetailPowerTips = {
  Name = UIWindowNames.ArmyFormationDetailPowerTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.ArmyFormationDetailPowerTips.Controller.ArmyFormationDetailPowerTipsCtrl"),
  View = require("UI.ArmyFormationDetailPowerTips.View.ArmyFormationDetailPowerTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPowerOverview/ArmyFormationDetailPowerTips.prefab"
}
return {ArmyFormationDetailPowerTips = ArmyFormationDetailPowerTips}
