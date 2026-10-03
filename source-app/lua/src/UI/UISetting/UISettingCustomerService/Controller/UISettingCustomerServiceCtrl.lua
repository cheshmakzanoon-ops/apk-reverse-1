local UISettingCustomerServiceCtrl = BaseClass("UISettingCustomerServiceCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingCustomerService)
end

UISettingCustomerServiceCtrl.CloseSelf = CloseSelf
return UISettingCustomerServiceCtrl
