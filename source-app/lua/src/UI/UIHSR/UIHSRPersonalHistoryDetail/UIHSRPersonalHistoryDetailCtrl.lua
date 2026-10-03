local UIHSRPersonalHistoryDetailCtrl = BaseClass("UIHSRPersonalHistoryDetailCtrl", UIBaseCtrl)

function UIHSRPersonalHistoryDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHSRPersonalHistoryDetail)
end

return UIHSRPersonalHistoryDetailCtrl
