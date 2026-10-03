local UILWPowerSourceCtrl = BaseClass("UILWPowerSourceCtrl", UIBaseCtrl)

function UILWPowerSourceCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPowerSource)
end

return UILWPowerSourceCtrl
