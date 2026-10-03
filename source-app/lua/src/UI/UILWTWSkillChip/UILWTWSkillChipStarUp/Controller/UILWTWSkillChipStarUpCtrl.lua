local UILWTWSkillChipStarUpCtrl = BaseClass("UILWTWSkillChipStarUpCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTWSkillChipStarUp)
end

UILWTWSkillChipStarUpCtrl.CloseSelf = CloseSelf
return UILWTWSkillChipStarUpCtrl
