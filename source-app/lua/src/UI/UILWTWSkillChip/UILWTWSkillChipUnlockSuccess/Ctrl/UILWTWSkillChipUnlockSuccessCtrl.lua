local UILWTWSkillChipUnlockSuccessCtrl = BaseClass("UILWTWSkillChipUnlockSuccessCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTWSkillChipUnlockSuccess)
end

UILWTWSkillChipUnlockSuccessCtrl.CloseSelf = CloseSelf
return UILWTWSkillChipUnlockSuccessCtrl
