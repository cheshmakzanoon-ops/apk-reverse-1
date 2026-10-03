local ValentineSendGiftSetting = {
  Name = UIWindowNames.ValentineSendGiftSetting,
  Layer = UILayer.Normal,
  Ctrl = require("UI.LWUIActValentineSendGiftSetting.Ctrl.LWUIActValentineSendGiftSettingCtrl"),
  View = require("UI.LWUIActValentineSendGiftSetting.View.LWUIActValentineSendGiftSettingView"),
  PrefabPath = "Assets/Main/Prefabs/UI/ActivityCenter/Valentine/SendGiftContent/ActValentineSendGiftSetting.prefab"
}
return {ValentineSendGiftSetting = ValentineSendGiftSetting}
