local UITemperatureMainCtrl = BaseClass("UITemperatureMainCtrl", UIBaseCtrl)

function UITemperatureMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITemperatureMain)
end

return UITemperatureMainCtrl
