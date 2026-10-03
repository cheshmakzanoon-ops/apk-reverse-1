local UIHeroSkillSimpleTipCtrl = BaseClass("UIHeroSkillSimpleTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroSkillSimpleTip)
end

UIHeroSkillSimpleTipCtrl.CloseSelf = CloseSelf
return UIHeroSkillSimpleTipCtrl
