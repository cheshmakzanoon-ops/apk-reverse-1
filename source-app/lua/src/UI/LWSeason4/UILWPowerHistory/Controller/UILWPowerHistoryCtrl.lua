local UILWPowerHistoryCtrl = BaseClass("UILWPowerHistoryCtrl", UIBaseCtrl)

function UILWPowerHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPowerHistory)
end

return UILWPowerHistoryCtrl
