local UILWDominatorSkillDetailCtrl = BaseClass("UILWDominatorSkillDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDominatorSkillDetail)
end

UILWDominatorSkillDetailCtrl.CloseSelf = CloseSelf
return UILWDominatorSkillDetailCtrl
