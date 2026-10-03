local UILWTacticalWeaponTip = {
  Name = UIWindowNames.UILWTacticalWeaponTip,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeaponTip.Controller.UILWTacticalWeaponTipCtrl"),
  View = require("UI.UILWTacticalWeaponTip.View.UILWTacticalWeaponTipView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UILWTacticalWeaponTip.prefab"
}
return {UILWTacticalWeaponTip = UILWTacticalWeaponTip}
