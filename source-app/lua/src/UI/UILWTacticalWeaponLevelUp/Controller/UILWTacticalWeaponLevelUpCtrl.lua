local UILWTacticalWeaponLevelUpCtrl = BaseClass("UILWTacticalWeaponLevelUpCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTacticalWeaponLevelUp)
end

UILWTacticalWeaponLevelUpCtrl.CloseSelf = CloseSelf
return UILWTacticalWeaponLevelUpCtrl
