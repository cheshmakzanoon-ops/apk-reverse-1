local UITacticalWeaponChipStageUpgrade = {
  Name = UIWindowNames.UITacticalWeaponChipStageUpgrade,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponChip.StageUpgrade.UITacticalWeaponChipStageUpgradeCtrl"),
  View = require("UI.UILWTacticalWeaponChip.StageUpgrade.UITacticalWeaponChipStageUpgradeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/UITacticalWeaponChipStageUpgrade.prefab"
}
return {UITacticalWeaponChipStageUpgrade = UITacticalWeaponChipStageUpgrade}
