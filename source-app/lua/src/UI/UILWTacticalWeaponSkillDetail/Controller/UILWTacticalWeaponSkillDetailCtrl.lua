local UILWTacticalWeaponSkillDetailCtrl = BaseClass("UILWTacticalWeaponSkillDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTacticalWeaponSkillDetail)
end

UILWTacticalWeaponSkillDetailCtrl.CloseSelf = CloseSelf
return UILWTacticalWeaponSkillDetailCtrl
