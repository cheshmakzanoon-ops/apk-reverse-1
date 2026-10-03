local UIConfiscateHistoryCtrl = BaseClass("UIConfiscateHistoryCtrl", UIBaseCtrl)

function UIConfiscateHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIConfiscateHistory)
end

return UIConfiscateHistoryCtrl
