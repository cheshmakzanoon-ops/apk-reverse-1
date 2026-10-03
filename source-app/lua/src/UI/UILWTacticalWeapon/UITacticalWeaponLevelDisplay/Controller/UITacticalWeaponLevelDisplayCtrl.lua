local UITacticalWeaponLevelDisplayCtrl = BaseClass("UITacticalWeaponLevelDisplayCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalWeaponLevelDisplay)
end

UITacticalWeaponLevelDisplayCtrl.CloseSelf = CloseSelf
return UITacticalWeaponLevelDisplayCtrl
