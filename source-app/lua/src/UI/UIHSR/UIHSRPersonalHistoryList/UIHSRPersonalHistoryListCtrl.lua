local UIHSRPersonalHistoryListCtrl = BaseClass("UIHSRPersonalHistoryListCtrl", UIBaseCtrl)

function UIHSRPersonalHistoryListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHSRPersonalHistoryList)
end

return UIHSRPersonalHistoryListCtrl
