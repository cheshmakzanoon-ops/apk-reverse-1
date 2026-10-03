local UIAllianceGovernmentSkillCtrl = BaseClass("UIAllianceGovernmentSkillCtrl", UIBaseCtrl)

function UIAllianceGovernmentSkillCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceGovernmentSkill)
end

return UIAllianceGovernmentSkillCtrl
