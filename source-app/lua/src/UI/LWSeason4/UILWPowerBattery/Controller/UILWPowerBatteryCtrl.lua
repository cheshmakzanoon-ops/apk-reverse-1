local UILWPowerBatteryCtrl = BaseClass("UILWPowerBatteryCtrl", UIBaseCtrl)

function UILWPowerBatteryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPowerBattery)
end

return UILWPowerBatteryCtrl
