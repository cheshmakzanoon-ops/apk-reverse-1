local UILWTWSkillChipDetailCtrl = BaseClass("UILWTWSkillChipDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTWSkillChipDetail)
end

UILWTWSkillChipDetailCtrl.CloseSelf = CloseSelf
return UILWTWSkillChipDetailCtrl
