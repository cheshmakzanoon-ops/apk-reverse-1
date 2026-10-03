local UILWTWSkillChipSkillEffectsCtrl = BaseClass("UILWTWSkillChipSkillEffectsCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTWSkillChipSkillEffects)
end

UILWTWSkillChipSkillEffectsCtrl.CloseSelf = CloseSelf
return UILWTWSkillChipSkillEffectsCtrl
