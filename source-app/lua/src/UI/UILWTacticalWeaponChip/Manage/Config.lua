local UITacticalChipManage = {
  Name = UIWindowNames.UITacticalChipManage,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponChip.Manage.Controller.UITacticalChipManageCtrl"),
  View = require("UI.UILWTacticalWeaponChip.Manage.View.UITacticalChipManageView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/UITacticalChipManage.prefab"
}
return {UITacticalChipManage = UITacticalChipManage}
