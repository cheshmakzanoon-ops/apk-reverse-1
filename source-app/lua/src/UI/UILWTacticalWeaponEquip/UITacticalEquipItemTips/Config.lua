local UITacticalEquipItemTips = {
  Name = UIWindowNames.UITacticalEquipItemTips,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponEquip.UITacticalEquipItemTips.Ctrl.UITacticalEquipItemTipsCtrl"),
  View = require("UI.UILWTacticalWeaponEquip.UITacticalEquipItemTips.View.UITacticalEquipItemTipsView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/EquipV2/UITacticalEquipItemTips.prefab"
}
return {UITacticalEquipItemTips = UITacticalEquipItemTips}
