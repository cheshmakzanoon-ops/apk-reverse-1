local UITemperatureHistoryCtrl = BaseClass("UITemperatureHistoryCtrl", UIBaseCtrl)

function UITemperatureHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITemperatureHistory)
end

return UITemperatureHistoryCtrl
