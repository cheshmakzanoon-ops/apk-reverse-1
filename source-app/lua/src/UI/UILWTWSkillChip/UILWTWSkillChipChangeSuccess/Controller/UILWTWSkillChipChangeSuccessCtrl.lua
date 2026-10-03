local UILWTWSkillChipChangeSuccessCtrl = BaseClass("UILWTWSkillChipChangeSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTWSkillChipChangeSuccess)
end

UILWTWSkillChipChangeSuccessCtrl.CloseSelf = CloseSelf
return UILWTWSkillChipChangeSuccessCtrl
