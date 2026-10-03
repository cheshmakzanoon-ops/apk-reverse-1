local UILWTWSkillChipSetUnlockCtrl = BaseClass("UILWTWSkillChipSetUnlockCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTWSkillChipSetUnlock)
end

UILWTWSkillChipSetUnlockCtrl.CloseSelf = CloseSelf
return UILWTWSkillChipSetUnlockCtrl
