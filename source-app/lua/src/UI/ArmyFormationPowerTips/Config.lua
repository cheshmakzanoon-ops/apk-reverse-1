local ArmyFormationPowerTips = {
  Name = UIWindowNames.ArmyFormationPowerTips,
  Layer = UILayer.Info,
  Ctrl = require("UI.ArmyFormationPowerTips.Controller.ArmyFormationPowerTipsCtrl"),
  View = require("UI.ArmyFormationPowerTips.View.ArmyFormationPowerTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWPowerOverview/ArmyFormationPowerTips.prefab"
}
return {ArmyFormationPowerTips = ArmyFormationPowerTips}
