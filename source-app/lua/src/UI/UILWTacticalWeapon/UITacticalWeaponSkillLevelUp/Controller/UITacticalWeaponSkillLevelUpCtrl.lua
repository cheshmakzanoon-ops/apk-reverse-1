local UITacticalWeaponSkillLevelUpCtrl = BaseClass("UITacticalWeaponSkillLevelUpCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalWeaponSkillLevelUp)
end

UITacticalWeaponSkillLevelUpCtrl.CloseSelf = CloseSelf
return UITacticalWeaponSkillLevelUpCtrl
