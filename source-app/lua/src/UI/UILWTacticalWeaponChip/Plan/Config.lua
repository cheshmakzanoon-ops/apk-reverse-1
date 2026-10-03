local UITacticalWeaponChipPlan = {
  Name = UIWindowNames.UITacticalWeaponChipPlan,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponChip.Plan.Controller.UITacticalWeaponChipPlanCtrl"),
  View = require("UI.UILWTacticalWeaponChip.Plan.View.UITacticalWeaponChipPlanView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/UITacticalWeaponChipPlan.prefab",
  HideBack = true
}
return {UITacticalWeaponChipPlan = UITacticalWeaponChipPlan}
