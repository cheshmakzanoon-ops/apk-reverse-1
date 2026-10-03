local UIAllianceGovernmentSkillHistoryCtrl = BaseClass("UIAllianceGovernmentSkillHistoryCtrl", UIBaseCtrl)

function UIAllianceGovernmentSkillHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceGovernmentSkillHistory)
end

return UIAllianceGovernmentSkillHistoryCtrl
