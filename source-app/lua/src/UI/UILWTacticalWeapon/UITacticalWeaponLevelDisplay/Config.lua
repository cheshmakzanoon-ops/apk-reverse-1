local UITacticalWeaponLevelDisplay = {
  Name = UIWindowNames.UITacticalWeaponLevelDisplay,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeapon.UITacticalWeaponLevelDisplay.Controller.UITacticalWeaponLevelDisplayCtrl"),
  View = require("UI.UILWTacticalWeapon.UITacticalWeaponLevelDisplay.View.UITacticalWeaponLevelDisplayView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UITacticalWeaponLevelDisplay.prefab"
}
return {UITacticalWeaponLevelDisplay = UITacticalWeaponLevelDisplay}
