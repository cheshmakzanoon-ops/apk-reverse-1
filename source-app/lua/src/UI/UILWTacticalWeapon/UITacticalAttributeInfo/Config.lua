local UITacticalAttributeInfo = {
  Name = UIWindowNames.UITacticalAttributeInfo,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UILWTacticalWeapon.UITacticalAttributeInfo.Controller.UITacticalAttributeInfoCtrl"),
  View = require("UI.UILWTacticalWeapon.UITacticalAttributeInfo.View.UITacticalAttributeInfoView"),
  PrefabPath = "Assets/Main/Prefabs/UI/LWUITacticalWeapon/UITacticalAttributeInfo.prefab"
}
return {UITacticalAttributeInfo = UITacticalAttributeInfo}
