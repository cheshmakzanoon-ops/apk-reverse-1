local UILWTacticalWeapon = {
  Name = UIWindowNames.UILWTacticalWeapon,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeapon.Controller.UILWTacticalWeaponCtrl"),
  View = require("UI.UILWTacticalWeapon.View.UILWTacticalWeaponView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UILWTacticalWeapon.prefab",
  HideBack = true,
  CustomKeyCodeEscape = true
}
return {UILWTacticalWeapon = UILWTacticalWeapon}
