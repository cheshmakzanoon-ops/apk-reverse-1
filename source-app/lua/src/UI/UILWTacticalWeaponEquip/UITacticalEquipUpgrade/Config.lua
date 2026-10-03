local UITacticalEquipUpgrade = {
  Name = UIWindowNames.UITacticalEquipUpgrade,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Ctrl.UITacticalEquipUpgradeCtrl"),
  View = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.View.UITacticalEquipUpgradeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/EquipV2/UITacticalEquipUpgrade.prefab"
}
return {UITacticalEquipUpgrade = UITacticalEquipUpgrade}
