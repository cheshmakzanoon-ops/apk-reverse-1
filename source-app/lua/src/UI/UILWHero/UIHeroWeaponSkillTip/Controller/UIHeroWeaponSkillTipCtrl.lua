local UIHeroWeaponSkillTipCtrl = BaseClass("UIHeroWeaponSkillTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroWeaponSkillTip)
end

UIHeroWeaponSkillTipCtrl.CloseSelf = CloseSelf
return UIHeroWeaponSkillTipCtrl
