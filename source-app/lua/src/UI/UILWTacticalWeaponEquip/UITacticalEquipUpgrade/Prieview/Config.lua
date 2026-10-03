local UITacticalEquipLevelPreview = {
  Name = UIWindowNames.UITacticalEquipLevelPreview,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Prieview.Ctrl.UITacticalEquipLevelPreviewCtrl"),
  View = require("UI.UILWTacticalWeaponEquip.UITacticalEquipUpgrade.Prieview.View.UITacticalEquipLevelPreviewView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/EquipV2/UITacticalEquipLevelPreview.prefab"
}
return {UITacticalEquipLevelPreview = UITacticalEquipLevelPreview}
