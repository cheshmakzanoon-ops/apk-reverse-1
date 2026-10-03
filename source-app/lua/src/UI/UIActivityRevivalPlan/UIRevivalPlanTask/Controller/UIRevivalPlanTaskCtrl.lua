local UIRevivalPlanTaskCtrl = BaseClass("UIRevivalPlanTaskCtrl", UIBaseCtrl)

function UIRevivalPlanTaskCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRevivalPlanTask)
end

return UIRevivalPlanTaskCtrl
