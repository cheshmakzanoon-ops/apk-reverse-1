local UITacticalWeaponSuperStageUpGold = {
  Name = UIWindowNames.UITacticalWeaponSuperStageUpGold,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeapon.UITacticalWeaponSuperStageUp.Controller.UITacticalWeaponSuperStageUpCtrl"),
  View = require("UI.UILWTacticalWeapon.UITacticalWeaponSuperStageUp.View.UITacticalWeaponSuperStageUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UITacticalWeaponSuperStageUpGold.prefab",
  CustomKeyCodeEscape = true
}
return {UITacticalWeaponSuperStageUpGold = UITacticalWeaponSuperStageUpGold}
