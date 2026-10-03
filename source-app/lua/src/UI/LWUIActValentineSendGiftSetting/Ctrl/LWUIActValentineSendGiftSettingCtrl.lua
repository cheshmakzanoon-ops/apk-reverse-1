local LWUIActValentineSendGiftSettingCtrl = BaseClass("LWUIActValentineSendGiftSettingCtrl", UIBaseCtrl)

function LWUIActValentineSendGiftSettingCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ValentineSendGiftSetting)
end

return LWUIActValentineSendGiftSettingCtrl
