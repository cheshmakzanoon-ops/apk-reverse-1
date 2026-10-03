local UISettingRedemptionCode = {
  Name = UIWindowNames.UISettingRedemptionCode,
  Layer = UILayer.Normal,
  Ctrl = require("UI.UISetting.UISettingRedemptionCode.Controller.UISettingRedemptionCodeCtrl"),
  View = require("UI.UISetting.UISettingRedemptionCode.View.UISettingRedemptionCodeView"),
  PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingRedemptionCode.prefab"
}
return {UISettingRedemptionCode = UISettingRedemptionCode}
