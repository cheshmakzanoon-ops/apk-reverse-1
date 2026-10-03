local UIHSRStationHistorySimpleListCtrl = BaseClass("UIHSRStationHistorySimpleListCtrl", UIBaseCtrl)

function UIHSRStationHistorySimpleListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHSRStationHistorySimpleList)
end

return UIHSRStationHistorySimpleListCtrl
