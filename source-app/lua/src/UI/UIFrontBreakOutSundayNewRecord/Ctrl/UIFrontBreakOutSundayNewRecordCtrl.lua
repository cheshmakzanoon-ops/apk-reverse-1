local UIFrontBreakOutSundayNewRecordCtrl = BaseClass("UIFrontBreakOutSundayNewRecordCtrl", UIBaseCtrl)

function UIFrontBreakOutSundayNewRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFrontBreakOutSundayNewRecord)
end

return UIFrontBreakOutSundayNewRecordCtrl
