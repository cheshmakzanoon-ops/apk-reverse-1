local UITacticalWeaponSuperStageUpMask = {
  Name = UIWindowNames.UITacticalWeaponSuperStageUpMask,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeapon.UITacticalWeaponSuperStageUpMask.UITacticalWeaponSuperStageUpMaskCtrl"),
  View = require("UI.UILWTacticalWeapon.UITacticalWeaponSuperStageUpMask.View.UITacticalWeaponSuperStageUpMaskView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UITacticalWeaponSuperStageUpMask.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {UITacticalWeaponSuperStageUpMask = UITacticalWeaponSuperStageUpMask}
