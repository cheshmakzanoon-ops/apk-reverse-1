local UIRevivalPlanRecordCtrl = BaseClass("UIRevivalPlanRecordCtrl", UIBaseCtrl)

function UIRevivalPlanRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRevivalPlanRecord)
end

return UIRevivalPlanRecordCtrl
