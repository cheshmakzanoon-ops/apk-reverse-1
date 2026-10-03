local UIAttackCityS0SuccessCtrl = BaseClass("UIAttackCityS0SuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISiegeSuccessS0)
end

UIAttackCityS0SuccessCtrl.CloseSelf = CloseSelf
return UIAttackCityS0SuccessCtrl
