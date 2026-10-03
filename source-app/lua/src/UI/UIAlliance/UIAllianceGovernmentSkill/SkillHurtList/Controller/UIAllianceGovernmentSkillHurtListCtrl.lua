local UIAllianceGovernmentSkillHurtListCtrl = BaseClass("UIAllianceGovernmentSkillHurtListCtrl", UIBaseCtrl)

function UIAllianceGovernmentSkillHurtListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceGovernmentSkillHurtList)
end

return UIAllianceGovernmentSkillHurtListCtrl
