local UITacticalChipStarDetail = {
  Name = UIWindowNames.UITacticalChipStarDetail,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponChip.StarDetail.Controller.UITacticalChipStarDetailCtrl"),
  View = require("UI.UILWTacticalWeaponChip.StarDetail.View.UITacticalChipStarDetailView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/ChipV2/UITacticalChipStarDetail.prefab"
}
return {UITacticalChipStarDetail = UITacticalChipStarDetail}
