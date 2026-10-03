local UILWAllianceSkillCtrl = BaseClass("UILWAllianceSkillCtrl", UIBaseCtrl)

function UILWAllianceSkillCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWAllianceSkill)
end

return UILWAllianceSkillCtrl
