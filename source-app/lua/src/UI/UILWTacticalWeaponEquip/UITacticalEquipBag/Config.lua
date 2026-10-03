local UITacticalEquipBag = {
  Name = UIWindowNames.UITacticalEquipBag,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponEquip.UITacticalEquipBag.Ctrl.UITacticalEquipBagCtrl"),
  View = require("UI.UILWTacticalWeaponEquip.UITacticalEquipBag.View.UITacticalEquipBagView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/EquipV2/UITacticalEquipBag.prefab"
}
return {UITacticalEquipBag = UITacticalEquipBag}
