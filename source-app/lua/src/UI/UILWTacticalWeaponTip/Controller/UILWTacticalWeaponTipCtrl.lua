local UILWTacticalWeaponTipCtrl = BaseClass("UILWTacticalWeaponTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTacticalWeaponTip)
end

UILWTacticalWeaponTipCtrl.CloseSelf = CloseSelf
return UILWTacticalWeaponTipCtrl
