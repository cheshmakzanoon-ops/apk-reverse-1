local UIGhostParkourRecordPopCtrl = BaseClass("UIGhostParkourRecordPopCtrl", UIBaseCtrl)

function UIGhostParkourRecordPopCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostParkourRecordPopView)
end

return UIGhostParkourRecordPopCtrl
