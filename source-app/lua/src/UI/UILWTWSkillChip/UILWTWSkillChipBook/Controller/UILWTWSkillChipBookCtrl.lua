local UILWTWSkillChipBookCtrl = BaseClass("UILWTWSkillChipBookCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTWSkillChipBook)
end

UILWTWSkillChipBookCtrl.CloseSelf = CloseSelf
return UILWTWSkillChipBookCtrl
