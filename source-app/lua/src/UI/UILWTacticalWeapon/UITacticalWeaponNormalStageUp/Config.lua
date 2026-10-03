local UITacticalWeaponNormalStageUp = {
  Name = UIWindowNames.UITacticalWeaponNormalStageUp,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeapon.UITacticalWeaponNormalStageUp.Controller.UITacticalWeaponNormalStageUpCtrl"),
  View = require("UI.UILWTacticalWeapon.UITacticalWeaponNormalStageUp.View.UITacticalWeaponNormalStageUpView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UITacticalWeaponNormalStageUp.prefab"
}
return {UITacticalWeaponNormalStageUp = UITacticalWeaponNormalStageUp}
