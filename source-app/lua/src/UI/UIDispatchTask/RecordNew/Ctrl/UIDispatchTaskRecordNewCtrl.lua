local UIDispatchTaskRecordNewCtrl = BaseClass("UIDispatchTaskRecordNewCtrl", UIBaseCtrl)

function UIDispatchTaskRecordNewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDispatchTaskRecordNewView)
end

return UIDispatchTaskRecordNewCtrl
