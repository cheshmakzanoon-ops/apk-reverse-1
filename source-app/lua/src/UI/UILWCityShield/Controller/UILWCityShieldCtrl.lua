local UILWCityShieldCtrl = BaseClass("UILWCityShieldCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWCityShield, {anim = true})
end

UILWCityShieldCtrl.CloseSelf = CloseSelf
return UILWCityShieldCtrl
