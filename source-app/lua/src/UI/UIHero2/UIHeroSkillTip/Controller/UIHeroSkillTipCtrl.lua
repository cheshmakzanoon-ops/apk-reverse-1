local UIHeroSkillTipCtrl = BaseClass("UIHeroSkillTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroSkillTip)
end

UIHeroSkillTipCtrl.CloseSelf = CloseSelf
return UIHeroSkillTipCtrl
