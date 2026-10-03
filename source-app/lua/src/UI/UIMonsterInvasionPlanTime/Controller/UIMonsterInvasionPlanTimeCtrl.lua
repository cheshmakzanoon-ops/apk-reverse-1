local UIMonsterInvasionPlanTimeCtrl = BaseClass("UIMonsterInvasionPlanTimeCtrl", UIBaseCtrl)

function UIMonsterInvasionPlanTimeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMonsterInvasionPlanTime)
end

return UIMonsterInvasionPlanTimeCtrl
