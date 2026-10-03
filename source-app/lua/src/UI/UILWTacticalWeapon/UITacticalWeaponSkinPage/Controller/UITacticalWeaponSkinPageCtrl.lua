local UITacticalWeaponSkinPageCtrl = BaseClass("UITacticalWeaponSkinPageCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalWeaponSkinPage)
end

UITacticalWeaponSkinPageCtrl.CloseSelf = CloseSelf
return UITacticalWeaponSkinPageCtrl
