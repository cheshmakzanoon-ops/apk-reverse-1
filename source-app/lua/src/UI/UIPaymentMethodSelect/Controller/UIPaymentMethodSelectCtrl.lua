local UIPaymentMethodSelectCtrl = BaseClass("UIPaymentMethodSelectCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPaymentMethodSelect)
end

UIPaymentMethodSelectCtrl.CloseSelf = CloseSelf
return UIPaymentMethodSelectCtrl
