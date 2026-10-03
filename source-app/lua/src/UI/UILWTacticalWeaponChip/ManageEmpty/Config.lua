local UITacticalChipManageEmpty = {
  Name = UIWindowNames.UITacticalChipManageEmpty,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponChip.ManageEmpty.Controller.UITacticalChipManageEmptyCtrl"),
  View = require("UI.UILWTacticalWeaponChip.ManageEmpty.View.UITacticalChipManageEmptyView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/UITacticalChipManageEmpty.prefab"
}
return {UITacticalChipManageEmpty = UITacticalChipManageEmpty}
