local T11SoldierResearchPlanCtrl = BaseClass("T11SoldierResearchPlanCtrl", UIBaseCtrl)

function T11SoldierResearchPlanCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.T11SoldierResearchPlan)
end

return T11SoldierResearchPlanCtrl
