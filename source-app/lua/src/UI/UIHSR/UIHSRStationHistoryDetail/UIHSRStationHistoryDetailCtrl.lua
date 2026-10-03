local UIHSRStationHistoryDetailCtrl = BaseClass("UIHSRStationHistoryDetailCtrl", UIBaseCtrl)

function UIHSRStationHistoryDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHSRStationHistoryDetail)
end

return UIHSRStationHistoryDetailCtrl
