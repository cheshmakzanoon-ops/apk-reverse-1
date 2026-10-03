local UIPaymentPreferenceSettingCtrl = BaseClass("UIPaymentPreferenceSettingCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPaymentPreferenceSetting)
end

UIPaymentPreferenceSettingCtrl.CloseSelf = CloseSelf
return UIPaymentPreferenceSettingCtrl
