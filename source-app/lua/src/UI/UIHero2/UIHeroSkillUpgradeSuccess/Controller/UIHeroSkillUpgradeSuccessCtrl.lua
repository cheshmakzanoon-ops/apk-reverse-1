local UIHeroSkillUpgradeSuccessCtrl = BaseClass("UIHeroSkillUpgradeSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroSkillUpgradeSuccess)
end

UIHeroSkillUpgradeSuccessCtrl.CloseSelf = CloseSelf
return UIHeroSkillUpgradeSuccessCtrl
